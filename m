Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1C4626D83
	for <lists+live-patching@lfdr.de>; Sun, 13 Nov 2022 03:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbiKMCon (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 12 Nov 2022 21:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiKMCom (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 12 Nov 2022 21:44:42 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C03511146;
        Sat, 12 Nov 2022 18:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PFC/3gpZ/w6uCN7OIH1RY890hMXcXfGXd92XAeM8pJY=; b=Ny1dJjzGyl4ZWzd34xFjfvi7ac
        rKKtpQ0qL2nD4hxEyZB2x0V2IXXLrRo0olJYKASn7Be+O8UNBjMwojK7ZIEfvAi5GCH1POJxXrfB1
        PODWL7PxfXn/Mz1WzB8Kvg6FAthsp39/8IUZZRO6zLeRTU/26PHAQX+Zl42K/xF09udZlAmZF6OZ9
        OSBcyufEPZKs6WndMhGQ0Ii4YUTWEcxL6a/ZGpNIjJsN3fT8pW2tAdQD3fTRQNe7MSCzcZhmcQ3/d
        TJ+nVkQgohLawzY8YG5FIrarkP1/z+6ewSSTZPGTIVEQsrHBpDRmpV6+QMYq+IjhaO/0Hk1s50zdz
        MoXR3tzQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ou2yw-009APa-FH; Sun, 13 Nov 2022 02:44:26 +0000
Date:   Sat, 12 Nov 2022 18:44:26 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Zhen Lei <thunder.leizhen@huawei.com>
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
Message-ID: <Y3BaCii5iz2TiUx7@bombadil.infradead.org>
References: <20221102084921.1615-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102084921.1615-1-thunder.leizhen@huawei.com>
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

On Wed, Nov 02, 2022 at 04:49:12PM +0800, Zhen Lei wrote:
> v7 --> v8:
> Sort the symbols by name and implement kallsyms_lookup_name() using a binary
> search. The performance is more than 20 times higher than that of v7. Of course,
> the memory overhead is also extended to (3 * kallsyms_num_syms) bytes. Discard
> all implementations of compression and then comparison in v7.
> 
> In addition, all sparse warnings about kallsyms_selftest.c are cleared.

Awesome work, I can't find a single thing I hate about this, but my
biggest conern is the lack of testing so I'm going to merge this to

