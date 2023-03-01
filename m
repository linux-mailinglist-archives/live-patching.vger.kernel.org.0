Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8451E6A6F1A
	for <lists+live-patching@lfdr.de>; Wed,  1 Mar 2023 16:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjCAPOs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 Mar 2023 10:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjCAPOr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 Mar 2023 10:14:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B220E3D91B
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 07:14:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6EFFB80EF8
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 15:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C79C433EF;
        Wed,  1 Mar 2023 15:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677683676;
        bh=cR4uFAjL40itItSF0Gerla53FzQmZfYt+kLnIfjtudI=;
        h=From:To:Cc:Subject:Date:From;
        b=SCSN4yP+fyQ9wNrN1cHDzThquJlPNN/gf08biYsdTCBLkwFReOMJ0HFpxtV03h0oP
         iHrTnxgKtHWvVCP1I3TiK493LR4b/3HGswk+d13t7bQnc2n0eD5x+R4Eq8hH24gelg
         8cJbRDjDXkLZT4uV+ofwkrW1GMn8IqsO0xrMqHKtH2EdNIKyvZmzF+fZGvWbWjPxgZ
         e2BeL2M0HxVI9g0+9+jb5Gg3rNvFiP5l28a7evaolGFA7uyXiCLAKr/HQ/dTOpBNCB
         DA5F/tCUWQKpvjEDOzjjL924OS37RVTbm64oqMsTl2riyP+OuldLQFozDvlz/JeW/h
         JbCrUWhdAvv/Q==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     x86@kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        live-patching@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/6] x86,objtool: Split UNWIND_HINT_EMPTY in two
Date:   Wed,  1 Mar 2023 07:13:06 -0800
Message-Id: <cover.1677683419.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Based on tip/objtool/core.

Mark reported that the ORC unwinder incorrectly marks an unwind as
reliable when the unwind terminates prematurely in the dark corners of
return_to_handler() due to lack of information about the next frame.

The problem is UNWIND_HINT_EMPTY is used in two different situations:
end-of-stack marker and undefined stack state.

Split it up into UNWIND_HINT_END_OF_STACK and UNWIND_HINT_UNDEFINED.

Josh Poimboeuf (6):
  objtool: Add objtool_types.h
  objtool: Use relative pointers for annotations
  objtool: Change UNWIND_HINT() argument order
  x86,objtool: Introduce ORC_TYPE_*
  x86,objtool: Separate unret validation from unwind hints
  x86,objtool: Split UNWIND_HINT_EMPTY in two

 .../livepatch/reliable-stacktrace.rst         |   2 +-
 MAINTAINERS                                   |   2 +-
 arch/x86/entry/entry_64.S                     |  26 +--
 arch/x86/include/asm/nospec-branch.h          |  14 +-
 arch/x86/include/asm/orc_types.h              |  12 +-
 arch/x86/include/asm/unwind_hints.h           |  18 +-
 arch/x86/kernel/ftrace_64.S                   |   2 +-
 arch/x86/kernel/head_64.S                     |  17 +-
 arch/x86/kernel/relocate_kernel_64.S          |  10 +-
 arch/x86/kernel/unwind_orc.c                  |  27 ++-
 arch/x86/lib/retpoline.S                      |   6 +-
 arch/x86/platform/pvh/head.S                  |   2 +-
 arch/x86/xen/xen-asm.S                        |   4 +-
 arch/x86/xen/xen-head.S                       |   4 +-
 include/linux/objtool.h                       |  81 +++----
 include/linux/objtool_types.h                 |  57 +++++
 scripts/sorttable.h                           |   2 +-
 tools/arch/x86/include/asm/orc_types.h        |  12 +-
 tools/include/linux/objtool.h                 | 200 ------------------
 tools/include/linux/objtool_types.h           |  57 +++++
 tools/objtool/check.c                         |  69 ++++--
 tools/objtool/include/objtool/check.h         |   4 +-
 tools/objtool/orc_dump.c                      |  15 +-
 tools/objtool/orc_gen.c                       |  43 ++--
 tools/objtool/sync-check.sh                   |   2 +-
 25 files changed, 314 insertions(+), 374 deletions(-)
 create mode 100644 include/linux/objtool_types.h
 delete mode 100644 tools/include/linux/objtool.h
 create mode 100644 tools/include/linux/objtool_types.h

-- 
2.39.1

