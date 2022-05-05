Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6791A51C8C8
	for <lists+live-patching@lfdr.de>; Thu,  5 May 2022 21:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346692AbiEETVb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 May 2022 15:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbiEETVa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 May 2022 15:21:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BE83585B;
        Thu,  5 May 2022 12:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F95AB82E60;
        Thu,  5 May 2022 19:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58367C385A8;
        Thu,  5 May 2022 19:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651778268;
        bh=S2VlxsKlNheP/UaljF4jK7i69JWNXtFiU1ZWtep/VvM=;
        h=From:To:Cc:Subject:Date:From;
        b=nl8guXmqkeqn8U0uP7nQcR6bT/b9QTUvlNCqHwCwe5Xh6gRXOCpq8g81dvZSYTfmL
         tFQfiK7MKkf0nC38lNniKXVg7vMuDxmAzR4zNiaA10VUWd7t0+tMz4sCcN0xDV6enG
         ZhD0D50LhOG9uAIuQ8VIBRlM5XYSgZlxMJPWQw8Qb3hm1F0Uay8X9gCsUBmyn2u5zh
         Dp44orNE87kfByd8GqNu3fHsco9lG+hbLb+GrI8sHn1sYuYFEz97mGIy6Y5KlyHr+d
         6FphjRfllmG7jCgrQ/XKdVRIVg319jWQW88Z3YDRzS2kSc2cLxBRo4CgLo1BMVVkaj
         beVeazmC3ARRA==
From:   Miguel Ojeda <ojeda@kernel.org>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Changbin Du <changbin.du@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        David Vernet <void@manifault.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jikos@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        live-patching@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>
Cc:     rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH v1 0/3] kallsyms: Rust requirements
Date:   Thu,  5 May 2022 21:16:42 +0200
Message-Id: <20220505191704.22812-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

These are the kallsyms patches we carry on the Rust patch series as
prerequisites. We were requested to submit them independently, so
here they are!

  - The first one is an improvement that may be applied even without
    the big symbol support.

  - The second adds support for "big" symbols without actually
    increasing the limit.

  - The third performs the actual increase.

Thanks!

Boqun Feng (1):
  kallsyms: avoid hardcoding the buffer size

Miguel Ojeda (2):
  kallsyms: support "big" kernel symbols
  kallsyms: increase maximum kernel symbol length to 512

 include/linux/kallsyms.h            |  2 +-
 kernel/kallsyms.c                   | 26 +++++++++++++---
 kernel/livepatch/core.c             |  4 +--
 scripts/kallsyms.c                  | 47 ++++++++++++++++++++++++-----
 tools/include/linux/kallsyms.h      |  2 +-
 tools/lib/perf/include/perf/event.h |  2 +-
 tools/lib/symbol/kallsyms.h         |  2 +-
 7 files changed, 68 insertions(+), 17 deletions(-)


base-commit: 672c0c5173427e6b3e2a9bbb7be51ceeec78093a
-- 
2.35.3

