Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8922B66BB60
	for <lists+live-patching@lfdr.de>; Mon, 16 Jan 2023 11:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjAPKMv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 16 Jan 2023 05:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjAPKLM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 16 Jan 2023 05:11:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEA91ABF0;
        Mon, 16 Jan 2023 02:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEE4FB80B14;
        Mon, 16 Jan 2023 10:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CB4C433F0;
        Mon, 16 Jan 2023 10:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673863817;
        bh=Aj54/H0x1pXEGgKMDyVJ8829D+rrZ/WP8KLwhEbUa+Y=;
        h=From:To:Cc:Subject:Date:From;
        b=F1pN3VelIJx5yiDHdoTYDGP9q6uij53ygLuV+Cty5y2QXokctCA+nmzy9DdqqXVgU
         js0P0XuliX0eYtfHSxVimTrx+TOmeoXBBZwEEU9ACiZkkkaupayahBDEFlExGsEchs
         MOmTbmR4aNK/+OJPvtQOUKHflPEytEmmly7sZQxCY4LtGHpoINOp5lPO42PFkBdyqx
         1FS8fGzxVm7CpWE0MBDBu+leVki/iYu1bVvRCTYvHlm3TLSZjNY9kNDaRk02TwOQzg
         lZ6kMQSdglAPUGIakq5pGSF1WqaM5D6xRxxay2Pkht39Wi8sHR3YLoy1iC8ad30poY
         IbpWAJ37akJSA==
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
Subject: [PATCHv3 bpf-next 0/3] kallsyms: Optimize the search for module symbols by livepatch and bpf
Date:   Mon, 16 Jan 2023 11:10:06 +0100
Message-Id: <20230116101009.23694-1-jolsa@kernel.org>
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

v3 changes:
  - fixed off by 1 issue, simplified condition, added acks [Song]
  - added module attach as subtest [Andrii]

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
 kernel/trace/bpf_trace.c                                   | 93 +++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------
 kernel/trace/ftrace.c                                      |  2 +-
 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c | 19 ++++++++++++++-----
 6 files changed, 79 insertions(+), 64 deletions(-)
