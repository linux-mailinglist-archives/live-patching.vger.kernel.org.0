Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A1A5BF6CD
	for <lists+live-patching@lfdr.de>; Wed, 21 Sep 2022 08:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiIUG4f (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 21 Sep 2022 02:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiIUG4d (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 21 Sep 2022 02:56:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF827961E;
        Tue, 20 Sep 2022 23:56:32 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BCCDF1F747;
        Wed, 21 Sep 2022 06:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663743390; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oh/7h2aPF1mzV4xLKAoOojrZB7GOctUET+2KxBXzCs0=;
        b=NTLtYUFjbBCX3rM7ziXwx+AQTuXbKy4GU7SFAo0bUYrWvPNU9glzBi1XqqNoB1D+dDdmLa
        ASk8JL/nvqGhRKWCoqsuLH//blAyDpjkTeV7gvzKeK0N1VK+2L2ONq3YkbeHZVVmEnz55g
        p+lZ9yzFvwCOi1R1kixwt0f/Dphu5RU=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8FC592C141;
        Wed, 21 Sep 2022 06:56:30 +0000 (UTC)
Date:   Wed, 21 Sep 2022 08:56:27 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules@vger.kernel.org
Subject: Re: [PATCH v2 7/8] livepatch: Improve the search performance of
 module_kallsyms_on_each_symbol()
Message-ID: <Yyq1m1pF7ErHjuMU@alley>
References: <20220909130016.727-1-thunder.leizhen@huawei.com>
 <20220909130016.727-8-thunder.leizhen@huawei.com>
 <YymtJwYB7Q9mTPgS@alley>
 <263d1b98-463f-79b0-a4ff-41b9af900e9c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <263d1b98-463f-79b0-a4ff-41b9af900e9c@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2022-09-20 22:01:44, Leizhen (ThunderTown) wrote:
> On 2022/9/20 20:08, Petr Mladek wrote:
> > On Fri 2022-09-09 21:00:15, Zhen Lei wrote:
> > 3. As a result the *mod parameter won't be used by any existing
> >    fn() callback and could be removed. This should be done as
> >    a separate patch. It touches also ftrace_lookup_symbols().
> 
> OK, I will do it tomorrow. The next version is v5.

Please, wait a bit. I have missed that there was already v4
that solved some my concerns. I am going to look at it.

Best Regards,
Petr
