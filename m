Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9983A629370
	for <lists+live-patching@lfdr.de>; Tue, 15 Nov 2022 09:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbiKOImu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Nov 2022 03:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbiKOImp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Nov 2022 03:42:45 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE0B15735;
        Tue, 15 Nov 2022 00:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JcJBCjh7l838Wq6UcVkfXVQPjk4/ajsDYeXjINPhA/E=; b=ZPUKQY17GwU9g+RK433OKjmi9/
        6CfbNHxq03HVJR8VRHDj/cUiQL9F6F3k2WA2upf9g6VDTkE5GB0kNhjN/l2IZBPbxNm+co5qmcMqm
        eqnwFzyRGf+FAA0Mro5KkRr83DrR3YpPDElOSuz0oNaVDV0CMj+m5O6DKcpkBTvsaX9aoRnkJQ/6v
        b8Cr3oAk2Re9CCq42yH1pCcOK/ovndsDqjzy2ddVolaMq+rXLZo7kIdz6X7lhWsxScMIJW87pJw4B
        9n/Lan41jb5fV87q7sPWeUBN/7UyQwQHvhc6NRc6AwddfRz/Jm6YVTwMZpWDyOR7OR5lrMTVguxld
        MMJBgjFQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ourWZ-008zwE-TE; Tue, 15 Nov 2022 08:42:31 +0000
Date:   Tue, 15 Nov 2022 00:42:31 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Zhen Lei <thunder.leizhen@huawei.com>, nick.alcock@oracle.com
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-modules@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH v9] kallsyms: Add self-test facility
Message-ID: <Y3NQ9xbT10JFvErS@bombadil.infradead.org>
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115083349.1662-1-thunder.leizhen@huawei.com>
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

On Tue, Nov 15, 2022 at 04:33:48PM +0800, Zhen Lei wrote:
> Added test cases for basic functions and performance of functions
> kallsyms_lookup_name(), kallsyms_on_each_symbol() and
> kallsyms_on_each_match_symbol(). It also calculates the compression rate
> of the kallsyms compression algorithm for the current symbol set.
> 
> The basic functions test begins by testing a set of symbols whose address
> values are known. Then, traverse all symbol addresses and find the
> corresponding symbol name based on the address. It's impossible to
> determine whether these addresses are correct, but we can use the above
> three functions along with the addresses to test each other. Due to the
> traversal operation of kallsyms_on_each_symbol() is too slow, only 60
> symbols can be tested in one second, so let it test on average once
> every 128 symbols. The other two functions validate all symbols.
> 
> If the basic functions test is passed, print only performance test
> results. If the test fails, print error information, but do not perform
> subsequent performance tests.
> 
> Start self-test automatically after system startup if
> CONFIG_KALLSYMS_SELFTEST=y.
> 
> Example of output content: (prefix 'kallsyms_selftest:' is omitted
>  start
>   ---------------------------------------------------------
>  | nr_symbols | compressed size | original size | ratio(%) |
>  |---------------------------------------------------------|
>  |     107543 |       1357912   |      2407433  |  56.40   |
>   ---------------------------------------------------------
>  kallsyms_lookup_name() looked up 107543 symbols
>  The time spent on each symbol is (ns): min=630, max=35295, avg=7353
>  kallsyms_on_each_symbol() traverse all: 11782628 ns
>  kallsyms_on_each_match_symbol() traverse all: 9261 ns
>  finish
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Thanks! Queued onto module-next.

  Luis
