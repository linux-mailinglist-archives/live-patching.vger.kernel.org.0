Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4391451E02F
	for <lists+live-patching@lfdr.de>; Fri,  6 May 2022 22:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443097AbiEFUjP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 May 2022 16:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443128AbiEFUjG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 May 2022 16:39:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C984B2AD;
        Fri,  6 May 2022 13:35:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8A8C60AF6;
        Fri,  6 May 2022 20:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A25C385A9;
        Fri,  6 May 2022 20:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651869320;
        bh=S2VlxsKlNheP/UaljF4jK7i69JWNXtFiU1ZWtep/VvM=;
        h=From:To:Cc:Subject:Date:From;
        b=ixIpy0yI+Knnbo5XqC13m/OPL0fJ+UK5oFisnjQWarBYeyI4STVtAaSI/K6q9qY6r
         RlZq6HL3qzTFcA5qBRU6/ebWZLXpOYDM8BjroQj0Q64/fu9dbQujWndT7ZKC1nSZqj
         LdRQCFIVBm13N9oJNa/osmgaA2iDMvTaeKck/mZUU5pcD+GYiN0d//6aXmpNR4InxI
         x/0a/2JTllqzfBng0Y5wIej51LvYUQr+TXNc3linvBH9dzyIAAfbeR/abUXfBOAnWM
         6O9B8yEu7bj9+jGcQpRZfDr1c0Wc0y6/CFmbv3fdhHb/l7y8rNPu4NR6564FcXsoq6
         1b2ATuR2JdTWA==
From:   Miguel Ojeda <ojeda@kernel.org>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Bixuan Cui <cuibixuan@huawei.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Changbin Du <changbin.du@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        David Vernet <void@manifault.com>, Gary Guo <gary@garyguo.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jikos@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        live-patching@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Wedson Almeida Filho <wedsonaf@google.com>
Cc:     rust-for-linux@vger.kernel.org
Subject: [PATCH v2 0/3] kallsyms: Rust requirements
Date:   Fri,  6 May 2022 22:34:21 +0200
Message-Id: <20220506203443.24721-1-ojeda@kernel.org>
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

