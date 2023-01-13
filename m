Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D36D66A6FE
	for <lists+live-patching@lfdr.de>; Sat, 14 Jan 2023 00:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjAMXX6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 Jan 2023 18:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjAMXX4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 Jan 2023 18:23:56 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3960A6719A;
        Fri, 13 Jan 2023 15:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uo0wRiUMsv1attXrd3ti/SMjYXEvY7sRfF3P5n6hjy4=; b=eHWl7lsza7bgtbnqAvN1J3bq1g
        DUrk7ERX7EEh4J3gB8cw9WMHNaggBGcSmfLA7HrkBfZQa5BJBMFjQMaB7UmaQu/ineehsEae0tXwd
        s5XTBCLtHnkziGdmguP5koz3LomIjOTwdvW8A7MkURcQTSU42bdyt0gHZGif0EatHjwegnzdPn8IN
        X4N1RtTPMO9ZH5KLcLzzTv7EhSfdgClgo5y7p3l0bOAQ3YjjnClCmjr/iMdz+Hv7Lw18+JYRedOkB
        Q/xNjGundNi1aBMwhvHSLNgc7F3sG+5jtAUYVcCiU4+jrkYrxWffMlUJlN3GRlKJbSF+799RfIA07
        zCEnT9iw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGTOW-004oWc-EH; Fri, 13 Jan 2023 23:23:34 +0000
Date:   Fri, 13 Jan 2023 15:23:32 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, bpf@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH v3] kallsyms: Remove the performance test from
 kallsyms_selftest.c
Message-ID: <Y8Hn9Bd7XFGkBnWO@bombadil.infradead.org>
References: <20230110130121.1279-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110130121.1279-1-thunder.leizhen@huawei.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jan 10, 2023 at 09:01:21PM +0800, Zhen Lei wrote:
> Suggested-by: Petr Mladek <pmladek@suse.com>

I've dropped this in favor of Nick's fix and pushed to Linus.

  Luis
