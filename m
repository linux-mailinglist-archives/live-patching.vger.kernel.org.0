Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B68F6292BE
	for <lists+live-patching@lfdr.de>; Tue, 15 Nov 2022 08:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiKOHyX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Nov 2022 02:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiKOHyV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Nov 2022 02:54:21 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7108417E3B;
        Mon, 14 Nov 2022 23:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zYOTZjlkx5N43x+jgA5oOKkfLzebaasHrimRrvaxfhA=; b=y9fePODp/mVG5AWCEuWQImgZtL
        Z8GGvBVn/ZLcagM0FvEmi1DUTSZJbAnSNXlRyXDm7E1YckDXll9A5ixR1mAxS3CAPzwS6fJDrBwkz
        QXW1exnGFIFVRk+feH03k1YPFtWbOpriJKHTyWmj0j8Vg0o2Q04E1ZPNrmEzMDAFw8pYXcs6oQot5
        UH8f0ZdsDnzVo4NKE6P1bsK0D2l8mLrkCDKkwoPfRzrRKJfXNllyMjRSQpLS8Jz3ciYxidJ0cWq2L
        8bUBkvGOxuib6tyk1AIdg34zgfokKnyV9pfkF0dGJzp2xNH190hjAeffaSvmClMQXhQjxQKP9FDMN
        fib5NJ4g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ouqlk-008k4U-Jc; Tue, 15 Nov 2022 07:54:08 +0000
Date:   Mon, 14 Nov 2022 23:54:08 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        Jiri Olsa <olsajiri@gmail.com>, nick.alcock@oracle.com
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
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
Message-ID: <Y3NFoLn/GOJybXoc@bombadil.infradead.org>
References: <Y3HyrIwlZPYM8zYd@krava>
 <050b7513-4a20-75c7-0574-185004770329@huawei.com>
 <Y3IJ5GjrXBYDbfnA@krava>
 <ad637488-930e-33c1-558c-fc03d848afa8@huawei.com>
 <Y3IY6gzDtk1ze3u7@krava>
 <955eebae-0b36-d13f-0199-2f1b32af7da6@huawei.com>
 <Y3JB++KOXxMWWX35@krava>
 <Y3JivLcvbHNcIcSB@bombadil.infradead.org>
 <df46ad45-2de4-0300-4afa-5788463d712a@huawei.com>
 <Y3NADwGUIvfwnGTp@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3NADwGUIvfwnGTp@krava>
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

On Tue, Nov 15, 2022 at 08:30:23AM +0100, Jiri Olsa wrote:
> On Tue, Nov 15, 2022 at 10:10:16AM +0800, Leizhen (ThunderTown) wrote:
> > 
> > 
> > On 2022/11/14 23:46, Luis Chamberlain wrote:
> > > On Mon, Nov 14, 2022 at 02:26:19PM +0100, Jiri Olsa wrote:
> > >> I'll check on that, meanwhile if we could keep the module argument,
> > >> that'd be great
> > > 
> > > As Leizhen suggested I could just drop patches:
> > > 
> > > 7/9 livepatch: Improve the search performance of module_kallsyms_on_each_symbol()
> > > 8/9 kallsyms: Delete an unused parameter related to kallsyms_on_each_symbol()
> > > 
> > > Then after the next kernel is released this can be relooked at.
> > > If this is agreeable let me know.
> > 
> > I'm OK.
> 
> sounds good, thanks

OK thanks, I dropped the last selftest patch as well, and pushed to
modules-next.  Leizhen, can you enhance the selftest for the new module
requirement and repost?

Stephen, you can drop your fix from linux-next, hopefully there should
no longer be any merge conflicts. The module requirement will stick for
now.

Thanks,

  Luis
