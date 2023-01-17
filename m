Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A11866E211
	for <lists+live-patching@lfdr.de>; Tue, 17 Jan 2023 16:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjAQP0a (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 17 Jan 2023 10:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbjAQP0A (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 17 Jan 2023 10:26:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD4242BD2;
        Tue, 17 Jan 2023 07:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ncBv23GBOtVznu5V8yi8Fc2pb7QmZGyIJBgsXfrjyek=; b=KJCkWqqMZy63Yo91dHyY2RQzHo
        w872tiYCR/EYTCrC95EHnwhStO1BlLYn/Eg+B+1WrkB1t+yqmuhGs4NOl4ReTT4mwDre2snbodNQD
        E8B0U4FlRFtmbnwR+l1NT6ocueYvW6v4y0jP7DRJB9NsaWcyBb9gLz5vkPxnmk9yfANmBF3sS/rF4
        N1LTKU7gwdn5pINdk+eyvGP/TCFWQAzg9UyboKd2pRwcpkdbZizwpJ7FKsLp+ilAoCP37wX73Yzpy
        qsoxuyvfdSqZdaBGoHhABOtnMdt3MLTeEMpFyMwGkivb0UsyOSG7pjkpL8F72uoRoULlCmLQzD2c5
        vojvzhPg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pHnqI-00EpSF-Sk; Tue, 17 Jan 2023 15:25:42 +0000
Date:   Tue, 17 Jan 2023 07:25:42 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        live-patching@vger.kernel.org, linux-modules@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCHv3 bpf-next 1/3] livepatch: Improve the search performance
 of module_kallsyms_on_each_symbol()
Message-ID: <Y8a99kCXd7XL8UaK@bombadil.infradead.org>
References: <20230116101009.23694-1-jolsa@kernel.org>
 <20230116101009.23694-2-jolsa@kernel.org>
 <alpine.LSU.2.21.2301171546520.24433@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2301171546520.24433@pobox.suse.cz>
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

On Tue, Jan 17, 2023 at 03:47:15PM +0100, Miroslav Benes wrote:
> On Mon, 16 Jan 2023, Jiri Olsa wrote:
> 
> > From: Zhen Lei <thunder.leizhen@huawei.com>
> > 
> > Currently we traverse all symbols of all modules to find the specified
> > function for the specified module. But in reality, we just need to find
> > the given module and then traverse all the symbols in it.
> > 
> > Let's add a new parameter 'const char *modname' to function
> > module_kallsyms_on_each_symbol(), then we can compare the module names
> > directly in this function and call hook 'fn' after matching. If 'modname'
> > is NULL, the symbols of all modules are still traversed for compatibility
> > with other usage cases.
> > 
> > Phase1: mod1-->mod2..(subsequent modules do not need to be compared)
> >                 |
> > Phase2:          -->f1-->f2-->f3
> > 
> > Assuming that there are m modules, each module has n symbols on average,
> > then the time complexity is reduced from O(m * n) to O(m) + O(n).
> > 
> > Reviewed-by: Petr Mladek <pmladek@suse.com>
> > Acked-by: Song Liu <song@kernel.org>
> > Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> Acked-by: Miroslav Benes <mbenes@suse.cz>

Yes, queued up, thanks!

  Luis
