#!/usr/bin/env ruby

require 'securerandom'
require 'fileutils'

# 项目配置
PROJECT_NAME = "MarketingAnalysisApp"
BUNDLE_ID = "com.marketing.MarketingAnalysisApp"
DEPLOYMENT_TARGET = "15.0"

puts "🚀 正在创建 Xcode 项目..."

# 创建项目目录
project_dir = "#{PROJECT_NAME}.xcodeproj"
FileUtils.mkdir_p(project_dir)

# 生成唯一的 UUID
def uuid
  SecureRandom.uuid.upcase.gsub('-', '')
end

# 项目对象 UUIDs
project_uuid = uuid
main_group_uuid = uuid
app_group_uuid = uuid
models_group_uuid = uuid
services_group_uuid = uuid
views_group_uuid = uuid
utils_group_uuid = uuid
assets_group_uuid = uuid
products_group_uuid = uuid

target_uuid = uuid
build_config_list_uuid = uuid
debug_config_uuid = uuid
release_config_uuid = uuid
project_config_list_uuid = uuid
project_debug_config_uuid = uuid
project_release_config_uuid = uuid

sources_build_phase_uuid = uuid
frameworks_build_phase_uuid = uuid
resources_build_phase_uuid = uuid

# 源文件 UUIDs
app_file_uuid = uuid
app_file_ref_uuid = uuid
marketing_report_uuid = uuid
marketing_report_ref_uuid = uuid
api_service_uuid = uuid
api_service_ref_uuid = uuid
voice_service_uuid = uuid
voice_service_ref_uuid = uuid
content_view_uuid = uuid
content_view_ref_uuid = uuid
voice_query_view_uuid = uuid
voice_query_view_ref_uuid = uuid
info_plist_ref_uuid = uuid
assets_ref_uuid = uuid
product_ref_uuid = uuid

# 创建 project.pbxproj 文件
pbxproj_content = <<~PBXPROJ
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
		#{app_file_uuid} /* MarketingAnalysisApp.swift in Sources */ = {isa = PBXBuildFile; fileRef = #{app_file_ref_uuid} /* MarketingAnalysisApp.swift */; };
		#{content_view_uuid} /* ContentView.swift in Sources */ = {isa = PBXBuildFile; fileRef = #{content_view_ref_uuid} /* ContentView.swift */; };
		#{voice_query_view_uuid} /* VoiceQueryView.swift in Sources */ = {isa = PBXBuildFile; fileRef = #{voice_query_view_ref_uuid} /* VoiceQueryView.swift */; };
		#{marketing_report_uuid} /* MarketingReport.swift in Sources */ = {isa = PBXBuildFile; fileRef = #{marketing_report_ref_uuid} /* MarketingReport.swift */; };
		#{api_service_uuid} /* APIService.swift in Sources */ = {isa = PBXBuildFile; fileRef = #{api_service_ref_uuid} /* APIService.swift */; };
		#{voice_service_uuid} /* VoiceService.swift in Sources */ = {isa = PBXBuildFile; fileRef = #{voice_service_ref_uuid} /* VoiceService.swift */; };
		#{uuid} /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = #{assets_ref_uuid} /* Assets.xcassets */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		#{product_ref_uuid} /* #{PROJECT_NAME}.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = #{PROJECT_NAME}.app; sourceTree = BUILT_PRODUCTS_DIR; };
		#{app_file_ref_uuid} /* MarketingAnalysisApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MarketingAnalysisApp.swift; sourceTree = "<group>"; };
		#{content_view_ref_uuid} /* ContentView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ContentView.swift; sourceTree = "<group>"; };
		#{voice_query_view_ref_uuid} /* VoiceQueryView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = VoiceQueryView.swift; sourceTree = "<group>"; };
		#{marketing_report_ref_uuid} /* MarketingReport.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MarketingReport.swift; sourceTree = "<group>"; };
		#{api_service_ref_uuid} /* APIService.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = APIService.swift; sourceTree = "<group>"; };
		#{voice_service_ref_uuid} /* VoiceService.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = VoiceService.swift; sourceTree = "<group>"; };
		#{assets_ref_uuid} /* Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; };
		#{info_plist_ref_uuid} /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		#{frameworks_build_phase_uuid} /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		#{project_uuid} = {
			isa = PBXGroup;
			children = (
				#{app_group_uuid} /* App */,
				#{products_group_uuid} /* Products */,
			);
			sourceTree = "<group>";
		};
		#{products_group_uuid} /* Products */ = {
			isa = PBXGroup;
			children = (
				#{product_ref_uuid} /* #{PROJECT_NAME}.app */,
			);
			name = Products;
			sourceTree = "<group>";
		};
		#{app_group_uuid} /* App */ = {
			isa = PBXGroup;
			children = (
				#{app_file_ref_uuid} /* MarketingAnalysisApp.swift */,
				#{models_group_uuid} /* Models */,
				#{services_group_uuid} /* Services */,
				#{views_group_uuid} /* Views */,
				#{assets_ref_uuid} /* Assets.xcassets */,
				#{info_plist_ref_uuid} /* Info.plist */,
			);
			path = App;
			sourceTree = "<group>";
		};
		#{models_group_uuid} /* Models */ = {
			isa = PBXGroup;
			children = (
				#{marketing_report_ref_uuid} /* MarketingReport.swift */,
			);
			path = Models;
			sourceTree = "<group>";
		};
		#{services_group_uuid} /* Services */ = {
			isa = PBXGroup;
			children = (
				#{api_service_ref_uuid} /* APIService.swift */,
				#{voice_service_ref_uuid} /* VoiceService.swift */,
			);
			path = Services;
			sourceTree = "<group>";
		};
		#{views_group_uuid} /* Views */ = {
			isa = PBXGroup;
			children = (
				#{content_view_ref_uuid} /* ContentView.swift */,
				#{voice_query_view_ref_uuid} /* VoiceQueryView.swift */,
			);
			path = Views;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		#{target_uuid} /* #{PROJECT_NAME} */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = #{build_config_list_uuid} /* Build configuration list for PBXNativeTarget "#{PROJECT_NAME}" */;
			buildPhases = (
				#{sources_build_phase_uuid} /* Sources */,
				#{frameworks_build_phase_uuid} /* Frameworks */,
				#{resources_build_phase_uuid} /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = #{PROJECT_NAME};
			productName = #{PROJECT_NAME};
			productReference = #{product_ref_uuid} /* #{PROJECT_NAME}.app */;
			productType = "com.apple.product-type.application";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		#{main_group_uuid} /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeCheck = 1500;
				TargetAttributes = {
					#{target_uuid} = {
						CreatedOnToolsVersion = 15.0;
					};
				};
			};
			buildConfigurationList = #{project_config_list_uuid} /* Build configuration list for PBXProject "#{PROJECT_NAME}" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = #{project_uuid};
			productRefGroup = #{products_group_uuid} /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				#{target_uuid} /* #{PROJECT_NAME} */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		#{resources_build_phase_uuid} /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				#{uuid} /* Assets.xcassets in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		#{sources_build_phase_uuid} /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				#{app_file_uuid} /* MarketingAnalysisApp.swift in Sources */,
				#{content_view_uuid} /* ContentView.swift in Sources */,
				#{voice_query_view_uuid} /* VoiceQueryView.swift in Sources */,
				#{marketing_report_uuid} /* MarketingReport.swift in Sources */,
				#{api_service_uuid} /* APIService.swift in Sources */,
				#{voice_service_uuid} /* VoiceService.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		#{debug_config_uuid} /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = App/Info.plist;
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				IPHONEOS_DEPLOYMENT_TARGET = #{DEPLOYMENT_TARGET};
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_TEAM = "";
				PRODUCT_BUNDLE_IDENTIFIER = #{BUNDLE_ID};
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Debug;
		};
		#{release_config_uuid} /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = App/Info.plist;
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				IPHONEOS_DEPLOYMENT_TARGET = #{DEPLOYMENT_TARGET};
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_TEAM = "";
				PRODUCT_BUNDLE_IDENTIFIER = #{BUNDLE_ID};
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Release;
		};
		#{project_debug_config_uuid} /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				GCC_C_LANGUAGE_STANDARD = gnu11;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = #{DEPLOYMENT_TARGET};
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			};
			name = Debug;
		};
		#{project_release_config_uuid} /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_C_LANGUAGE_STANDARD = gnu11;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = #{DEPLOYMENT_TARGET};
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				SWIFT_OPTIMIZATION_LEVEL = "-O";
				VALIDATE_PRODUCT = YES;
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		#{build_config_list_uuid} /* Build configuration list for PBXNativeTarget "#{PROJECT_NAME}" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				#{debug_config_uuid} /* Debug */,
				#{release_config_uuid} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		#{project_config_list_uuid} /* Build configuration list for PBXProject "#{PROJECT_NAME}" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				#{project_debug_config_uuid} /* Debug */,
				#{project_release_config_uuid} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = #{main_group_uuid} /* Project object */;
}
PBXPROJ

# 写入文件
File.write("#{project_dir}/project.pbxproj", pbxproj_content)

# 创建 xcscheme
xcscheme_dir = "#{project_dir}/xcshareddata/xcschemes"
FileUtils.mkdir_p(xcscheme_dir)

scheme_content = <<~SCHEME
<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1500"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "#{target_uuid}"
               BuildableName = "#{PROJECT_NAME}.app"
               BlueprintName = "#{PROJECT_NAME}"
               ReferencedContainer = "container:#{PROJECT_NAME}.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES">
      <Testables>
      </Testables>
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "#{target_uuid}"
            BuildableName = "#{PROJECT_NAME}.app"
            BlueprintName = "#{PROJECT_NAME}"
            ReferencedContainer = "container:#{PROJECT_NAME}.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "#{target_uuid}"
            BuildableName = "#{PROJECT_NAME}.app"
            BlueprintName = "#{PROJECT_NAME}"
            ReferencedContainer = "container:#{PROJECT_NAME}.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
SCHEME

File.write("#{xcscheme_dir}/#{PROJECT_NAME}.xcscheme", scheme_content)

# 创建 workspace 文件
workspace_dir = "#{project_dir}/project.xcworkspace"
FileUtils.mkdir_p(workspace_dir)

workspace_content = <<~WORKSPACE
<?xml version="1.0" encoding="UTF-8"?>
<Workspace
   version = "1.0">
   <FileRef
      location = "self:">
   </FileRef>
</Workspace>
WORKSPACE

File.write("#{workspace_dir}/contents.xcworkspacedata", workspace_content)

puts "✅ Xcode 项目已生成: #{project_dir}"
puts ""
puts "📱 接下来的步骤:"
puts "1. 在 Xcode 中打开项目: open #{PROJECT_NAME}.xcodeproj"
puts "2. 在 Signing & Capabilities 中选择你的 Team（开发者账号）"
puts "3. 添加 Speech Capability"
puts "4. 连接你的 iPhone"
puts "5. 点击运行按钮 ▶️"
puts ""
puts "🎉 项目创建完成！"
