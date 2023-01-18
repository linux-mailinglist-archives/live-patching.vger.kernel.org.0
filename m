Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43EFF670ED7
	for <lists+live-patching@lfdr.de>; Wed, 18 Jan 2023 01:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjARAlt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 17 Jan 2023 19:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjARAlJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 17 Jan 2023 19:41:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CC7366BD;
        Tue, 17 Jan 2023 16:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=utRFnR99NxpzDHlLUBWhedA5Z4Qq6S0lgjsdASsjQgw=; b=gLiHq7h9ZLBOPUCCcIFpEOUKme
        G9Ezvqeq3LqMLnnKcumYSR9pJ5akTuu8CjhiUuTR25iQZOQ+woIQSjYTRJI/z/MFNA8cG7dMdpY/U
        XUAbrdYMJwChjFf0WqZKDPJj6FOXZ0iwBejJVB6AJfFbLiqQPwluE5ObI06U6b9/Cd928fUWRhMAF
        +0HpMcrHGNVbN4DeT06Q/s2jxahuNXnKegsqJgcdjNhKn2T1TGAMndDowJuGppFwPfA59qY69BW61
        6li5vAr8fJJswsydGnqYHt/8WTEwAih4YzfmbUycdszkAdmx7r21yfp+yzRuw8P4pjET8T7YgT+EO
        hcrqaZwg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pHw8b-00GKCk-PD; Wed, 18 Jan 2023 00:17:09 +0000
Date:   Tue, 17 Jan 2023 16:17:09 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
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
        Mark Rutland <mark.rutland@arm.com>,
        Nick Alcock <nick.alcock@oracle.com>
Subject: Re: [PATCHv3 bpf-next 1/3] livepatch: Improve the search performance
 of module_kallsyms_on_each_symbol()
Message-ID: <Y8c6hUswpwg7g83v@bombadil.infradead.org>
References: <20230116101009.23694-1-jolsa@kernel.org>
 <20230116101009.23694-2-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116101009.23694-2-jolsa@kernel.org>
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

On Mon, Jan 16, 2023 at 11:10:07AM +0100, Jiri Olsa wrote:
> From: Zhen Lei <thunder.leizhen@huawei.com>
> 
> Currently we traverse all symbols of all modules to find the specified
> function for the specified module. But in reality, we just need to find
> the given module and then traverse all the symbols in it.
> 
> Let's add a new parameter 'const char *modname' to function
> module_kallsyms_on_each_symbol(), then we can compare the module names
> directly in this function and call hook 'fn' after matching. If 'modname'
> is NULL, the symbols of all modules are still traversed for compatibility
> with other usage cases.
> 
> Phase1: mod1-->mod2..(subsequent modules do not need to be compared)
>                 |
> Phase2:          -->f1-->f2-->f3
> 
> Assuming that there are m modules, each module has n symbols on average,
> then the time complexity is reduced from O(m * n) to O(m) + O(n).
> 
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Acked-by: Song Liu <song@kernel.org>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

I'm happy for folks to take this through another tree. I was merging
kallsysm stuff on the modules tree to avoid conflicts with Nick Alcock's
work but after reviewing his v10 series it is quite clear that's no where near
ready now and I don't expect much conflicts even if it was.

  Luis
