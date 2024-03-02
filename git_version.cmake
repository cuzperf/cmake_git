# 获取最新的 git tag
execute_process(
    COMMAND git describe --tags --abbrev=0
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE LATEST_GIT_TAG
    OUTPUT_STRIP_TRAILING_WHITESPACE
    RESULT_VARIABLE GIT_COMMAND_RESULT
)
if(NOT GIT_COMMAND_RESULT EQUAL 0)
    message(FATAL_ERROR "Failed to run 'git describe' command.")
endif()

macro(GET_HASH_NAME TAG_NAME TAG_HASH)
execute_process(
    COMMAND git rev-parse --short ${TAG_NAME}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE ${TAG_HASH}
    OUTPUT_STRIP_TRAILING_WHITESPACE
    RESULT_VARIABLE GIT_REV_PARSE_RESULT_TAG
)
if(NOT GIT_REV_PARSE_RESULT_TAG EQUAL 0)
    message(FATAL_ERROR "Failed to run 'git rev-parse' command.")
endif()
endmacro()

# 获取最新的 git tag 对应的 （短）hash 值
GET_HASH_NAME(${LATEST_GIT_TAG} LATEST_GIT_TAG_HASH)
# 获取最新的commit（HEAD）对应的 （短） hash 值
GET_HASH_NAME(HEAD HEAD_COMMIT_HASH)

# 判断当前分支在本地是否有修改
execute_process(
    COMMAND git diff-index --quiet HEAD --
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    RESULT_VARIABLE GIT_CLEAN_RESULT
)

# 判断最新的 git tag 是否为最近的一次 commit（HEAD）且是否为干净的分支
if(${LATEST_GIT_TAG_HASH} STREQUAL ${HEAD_COMMIT_HASH})
    if(${GIT_CLEAN_RESULT} EQUAL 0)
        # 干净的分支且 git tag 就是 HEAD（可用于发版）
    else()
        # 不干净的分支，发版后有修改就编译了（常见于发版之后本地进行了修改后再编译）
        set(LATEST_GIT_TAG "${LATEST_GIT_TAG}(dirty)")
    endif()
else()
    if(${GIT_CLEAN_RESULT} EQUAL 0)
        # 干净的分支但 git tag 不是 HEAD（应该重新打 tag 再编译才可用于发版）
        set(LATEST_GIT_TAG "${LATEST_GIT_TAG}(${HEAD_COMMIT_HASH})")
    else()
        # 不干净的分支，本地有修改就编译（常见于正常开发）
        set(LATEST_GIT_TAG "${LATEST_GIT_TAG}(${HEAD_COMMIT_HASH}(dirty))")
    endif()
endif()

configure_file(git_version_info.h.in ${CMAKE_SOURCE_DIR}/git_version_info.h @ONLY)
