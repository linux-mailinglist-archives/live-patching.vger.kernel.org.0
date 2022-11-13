Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51980626D87
	for <lists+live-patching@lfdr.de>; Sun, 13 Nov 2022 03:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbiKMC4G (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 12 Nov 2022 21:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiKMC4F (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 12 Nov 2022 21:56:05 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C86FCFC;
        Sat, 12 Nov 2022 18:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=n2FZjuDTRyueWGV+1bDqjA8Dt8qN5j59vtPu2rlxA0A=; b=aD8cv3eyuaxKjPSu6aVE0sCIEp
        LfbxiDuC8D/2iE4D9VkNqB1wvUgA/lOq7IdBMKjnZThcaiIS9rqiT0c2Xpgc8/Kv5t1Eeg/nWa/W7
        eGn+zTAgL1Cpc2QlNs1WFGOimndSJoa2/iJVgTPFISQiZpXJidoyvug5n38dhdg1WDoa9ZzFfRIzY
        stvJ8OlBUcIA4hdM4or8cvmNWABH8etiGJvwRNlz35A3kgfHj6t0nhy+6kM4lBAwotL5mVYbIhZ1r
        V5tjFEnNtgoISywh5VYYrx1hiC1xestNrFXlYjQeQygGtGDZF/SUzSWzkx/zA7/mUp4fVSC8lEnBE
        Di7nD0MA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ou39v-009CCV-FY; Sun, 13 Nov 2022 02:55:47 +0000
Date:   Sat, 12 Nov 2022 18:55:47 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Nick Alcock <nick.alcock@oracle.com>, rostedt@goodmis.org
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
Subject: Re: [PATCH v8 0/9] kallsyms: Optimizes the performance of lookup
 symbols
Message-ID: <Y3Bcs5sT17IcyQZD@bombadil.infradead.org>
References: <20221102084921.1615-1-thunder.leizhen@huawei.com>
 <Y3BaCii5iz2TiUx7@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3BaCii5iz2TiUx7@bombadil.infradead.org>
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

On Sat, Nov 12, 2022 at 06:44:26PM -0800, Luis Chamberlain wrote:
> On Wed, Nov 02, 2022 at 04:49:12PM +0800, Zhen Lei wrote:
> > v7 --> v8:
> > Sort the symbols by name and implement kallsyms_lookup_name() using a binary
> > search. The performance is more than 20 times higher than that of v7. Of course,
> > the memory overhead is also extended to (3 * kallsyms_num_syms) bytes. Discard
> > all implementations of compression and then comparison in v7.
> > 
> > In addition, all sparse warnings about kallsyms_selftest.c are cleared.
> 
> Awesome work, I can't find a single thing I hate about this, but my
> biggest conern is the lack of testing so I'm going to merge this to

Sorry finished the email too fast, I just wanted to add Nick to the
thread as his work does tons of changes on scripts/kallsyms.c.

I was saying -- I'm just concern with the lack of testing so I have merged
this to modules-next and see what explodes over the next few weeks.
I'm also happy to drop this from modules-next and have it go through
the livepatching tree instead, but given Nick's work is dedicated
towards modules and it also touches on scripts/kallsyms.c a lot, to
avoid conflicts it felt best to merge that to modules for now in case
his changes get merged during the next merge window.

Let me know what folks prefer.

Obviously, if testing blows up we can drop the series.

Zhen, wouldn't ftrace benefit from the same
s/kallsyms_on_each_symbol/kallsyms_on_each_match_symbol ?

  Luis
