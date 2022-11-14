Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52133628447
	for <lists+live-patching@lfdr.de>; Mon, 14 Nov 2022 16:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbiKNPqW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 14 Nov 2022 10:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236881AbiKNPqV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 14 Nov 2022 10:46:21 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1651B1FC;
        Mon, 14 Nov 2022 07:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9x5vXUVS9j7zcrrLvHEbPU1jldRv2IvumkmALbT7WOQ=; b=es7sY5YByhCNY/0aNK9ItyqSFW
        heM0jdDRk/pJ2hhroBLOqWSlW46Kyz72Pw+PW67G8LoByWH8a4yt3Ay5saODhqzIVVtiA+k+mKHwx
        2pBNIS4Gqt8B+xdgXO1KTB+PW984kOwaktN0TJgB/kFwsl1NZBTleucG0AXW/pbPXIO39LliJcQ1g
        OK82pnhzy89Uc1vOVwsS2CP/LZ/a0A0kTzbmVSpZX6lsfdAh+ILp9ARIcsNtG50/Wxk5xD4dL4blk
        5l38X1jX0wDkI32rfJIoIAj5fEr+Ey/wkGVectJwkguxZO0UR0tj7565qZdgi2rjc40DzMrFeJ85R
        UXpyRg6w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oubeu-002Pla-6A; Mon, 14 Nov 2022 15:46:04 +0000
Date:   Mon, 14 Nov 2022 07:46:04 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-modules@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v8 7/9] livepatch: Improve the search performance of
 module_kallsyms_on_each_symbol()
Message-ID: <Y3JivLcvbHNcIcSB@bombadil.infradead.org>
References: <20221102084921.1615-1-thunder.leizhen@huawei.com>
 <20221102084921.1615-8-thunder.leizhen@huawei.com>
 <Y3HyrIwlZPYM8zYd@krava>
 <050b7513-4a20-75c7-0574-185004770329@huawei.com>
 <Y3IJ5GjrXBYDbfnA@krava>
 <ad637488-930e-33c1-558c-fc03d848afa8@huawei.com>
 <Y3IY6gzDtk1ze3u7@krava>
 <955eebae-0b36-d13f-0199-2f1b32af7da6@huawei.com>
 <Y3JB++KOXxMWWX35@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3JB++KOXxMWWX35@krava>
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

On Mon, Nov 14, 2022 at 02:26:19PM +0100, Jiri Olsa wrote:
> I'll check on that, meanwhile if we could keep the module argument,
> that'd be great

As Leizhen suggested I could just drop patches:

7/9 livepatch: Improve the search performance of module_kallsyms_on_each_symbol()
8/9 kallsyms: Delete an unused parameter related to kallsyms_on_each_symbol()

Then after the next kernel is released this can be relooked at.
If this is agreeable let me know.

  Luis
