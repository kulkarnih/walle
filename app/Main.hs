module Main (main) where

import RIO
import App
import Downloader

appM :: AppM ()
appM = downloadWallpaper "wallhaven-9mjoy1.png" "https://w.wallhaven.cc/full/9m/wallhaven-9mjoy1.png"

env :: Env
env = Env "wallpapers" True

main :: IO ()
main = runApp appM env
