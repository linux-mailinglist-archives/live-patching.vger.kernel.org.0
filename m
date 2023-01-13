Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CEE669ABE
	for <lists+live-patching@lfdr.de>; Fri, 13 Jan 2023 15:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjAMOm5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 Jan 2023 09:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjAMOmU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 Jan 2023 09:42:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014E640C17;
        Fri, 13 Jan 2023 06:33:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F4C361F41;
        Fri, 13 Jan 2023 14:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00873C433EF;
        Fri, 13 Jan 2023 14:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673620391;
        bh=c2/eHOeJ8hv3rN2sbMnI77LITuYi0ZOFIxjM3mxMwEU=;
        h=From:To:Cc:Subject:Date:From;
        b=Egl0gYzczrT8rdS8sgWZPKkHm1tNJZFUMyWA3MoqyTv4XoHm1mbc3j5eXm4N16ylJ
         0V5p+bvgG4SQXvLa8PizJPnzPcgVaeefV1INYDeYp4pfNns/07i6TR6Pqz9/rXK795
         I1byl0+/OtxplnDtpzYsidxcl+FH3c7tTqLLo36VRWHsAtIOATNsL5bn/JVcRbfmQK
         jFjrDTSe+xD0uPR/nlPyFH1yPiD9eoEGRtM2jh0odnl2HUYnRZffFx0qLRTFpdHFNW
         zDtapmP4S7vU25JryqqOD5Jf9S/zb7eUOyXKt97yQojUZL/7UJOmgieFjMoEMnDn1Q
         Q9atmDJi90SmA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Cc:     bpf@vger.kernel.org, live-patching@vger.kernel.org,
        linux-modules@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCHv2 bpf-next 0/3] kallsyms: Optimize the search for module symbols by livepatch and bpf
Date:   Fri, 13 Jan 2023 15:33:00 +0100
Message-Id: <20230113143303.867580-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

hi,
sending new version of [1] patchset posted originally by Zhen Lei.
It contains 2 changes that improove search performance for livepatch
and bpf.

v2 changes:
  - reworked the bpf change and meassured the performance
  - adding new selftest to benchmark kprobe multi module attachment
  - skipping patch 3 as requested by Zhen Lei
  - added Reviewed-by for patch 1 [Petr Mladek]

thanks,
jirka


[1] https://lore.kernel.org/bpf/20221230112729.351-1-thunder.leizhen@huawei.com/
---
Jiri Olsa (2):
      selftests/bpf: Add serial_test_kprobe_multi_bench_attach_kernel/module tests
      bpf: Change modules resolving for kprobe multi link

Zhen Lei (1):
      livepatch: Improve the search performance of module_kallsyms_on_each_symbol()

 include/linux/module.h                                     |  6 ++++--
 kernel/livepatch/core.c                                    | 10 +---------
 kernel/module/kallsyms.c                                   | 13 ++++++++++++-
 kernel/trace/bpf_trace.c                                   | 95 ++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------
 kernel/trace/ftrace.c                                      |  2 +-
 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c | 21 ++++++++++++++++-----
 6 files changed, 83 insertions(+), 64 deletions(-)
