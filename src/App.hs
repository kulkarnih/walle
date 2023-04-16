{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module App
    ( AppM
    , Env(..)
    , runApp
    ) where

import RIO
import qualified RIO.ByteString as B
import qualified RIO.FilePath as F
import qualified Network.HTTP.Simple as HTTP
import Downloader

data Env = Env
  { wallpaperDir :: FilePath
  , envDebugMode :: Bool
  }

newtype AppM a = AppM {
  unApp :: ReaderT Env IO a
} deriving (Functor, Applicative, Monad, MonadIO, MonadReader Env)

instance MonadSaveWallpaper AppM where
  saveWallpaper name contents = do
    dir <- asks wallpaperDir
    B.writeFile (dir F.</> name) contents

instance MonadGetWallpaper AppM where
  getWallpaper = liftIO . getWallpaperFromUrl

instance HasDebugMode AppM where
  debugMode = asks envDebugMode

getWallpaperFromUrl :: URL -> IO B.ByteString
getWallpaperFromUrl url = fmap HTTP.getResponseBody $ HTTP.httpBS $ HTTP.parseRequest_ url

runApp :: AppM a -> Env -> IO a
runApp app = runReaderT (unApp app)
