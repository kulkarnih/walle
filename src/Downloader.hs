module Downloader
(
    HasDebugMode(..)
  , MonadGetWallpaper(..)
  , MonadSaveWallpaper(..)
  , URL
  , downloadWallpaper
) where

import RIO
import qualified RIO.ByteString as B
import Prelude (putStrLn)

type URL = String
type WallpaperName = String

class Monad m => MonadGetWallpaper m where
  getWallpaper :: URL -> m B.ByteString

class Monad m => MonadSaveWallpaper m where
  saveWallpaper :: WallpaperName -> B.ByteString -> m ()

class Monad m => HasDebugMode m where
  debugMode :: m Bool

downloadWallpaper :: 
  ( MonadGetWallpaper m,
    MonadSaveWallpaper m,
    MonadIO m,
    HasDebugMode m
  ) => WallpaperName -> URL -> m ()
downloadWallpaper name url = do
  debug <- debugMode
  when debug $ liftIO $ putStrLn "Getting contents"
  contents <- getWallpaper url
  when debug $ liftIO $ putStrLn "Saving wallpaper"
  saveWallpaper name contents

