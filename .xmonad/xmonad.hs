import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.NoBorders
import System.IO

myManageHook = composeAll
    [
        className =? "Gimp" --> doFloat,
		isFullscreen --> doFullFloat
    ]

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig {
		terminal = "urxvt",
		workspaces = ["1:main", "2:web", "3:irc", "4", "5", "6:gimp"],
		modMask = mod1Mask,
        manageHook = manageDocks <+> manageHook defaultConfig,
        --layoutHook = smartBorders (avoidStruts $ layoutHook defaultConfig),
        layoutHook = avoidStruts $ smartBorders $ layoutHook defaultConfig,
        logHook = dynamicLogWithPP xmobarPP {
            ppOutput = hPutStrLn xmproc,
            ppTitle = xmobarColor "green" "" . shorten 50
        }
    } `additionalKeys`
        [
            ((controlMask .|. mod1Mask, xK_l), spawn "slock"),
			((0, xK_Print), spawn "scrot -e 'mv $f ~/media/pictures/screenshots/'"),
			((controlMask, xK_Print), spawn "scrot -se 'mv $f ~/media/pictures/screenshots/'")
        ]
