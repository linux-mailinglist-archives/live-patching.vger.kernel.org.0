Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096286483D7
	for <lists+live-patching@lfdr.de>; Fri,  9 Dec 2022 15:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiLIOgy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Dec 2022 09:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiLIOgx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Dec 2022 09:36:53 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173B713F31;
        Fri,  9 Dec 2022 06:36:52 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id ABE111FF9C;
        Fri,  9 Dec 2022 14:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670596610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WX8KuOVecb6SzIYSsakpl/x1KTg6j7Cl5d2y2JO2ZUc=;
        b=ihWuwSN8geBq0c/UV33vGbwcKVS2xKZyoin1XpFmemGbRtb5izXrXhK+t14oLZzkV4wyF2
        6FyBikNpT1EEQs8foKYXh9dK9IUboTxOZA/m81RpEZ+9/iX9kCeX8wrF+/4bq+mNkJ3fYf
        zDFNV9ir8T1Rj5vxNUpdhRr4imz2T3A=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 84F3B2C141;
        Fri,  9 Dec 2022 14:36:49 +0000 (UTC)
Date:   Fri, 9 Dec 2022 15:36:49 +0100
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
Subject: Re: [PATCH] livepatch: Call klp_match_callback() in
 klp_find_callback() to avoid code duplication
Message-ID: <Y5NIAS8dtY/RUIRW@alley>
References: <20221207032304.2017-1-thunder.leizhen@huawei.com>
 <Y5L75x+W1NrWCOcm@alley>
 <aed3ca41-0f27-b44e-b95c-f7ed0a8ef468@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aed3ca41-0f27-b44e-b95c-f7ed0a8ef468@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-12-09 19:29:56, Leizhen (ThunderTown) wrote:
> 
> 
> On 2022/12/9 17:12, Petr Mladek wrote:
> > On Wed 2022-12-07 11:23:04, Zhen Lei wrote:
> >> The implementation of function klp_match_callback() is identical to the
> >> partial implementation of function klp_find_callback(). So call function
> >> klp_match_callback() in function klp_find_callback() instead of the
> >> duplicated code.
> >>
> >> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> > 
> > Thanks for cleaning this.
> > 
> > Reviewed-by: Petr Mladek <pmladek@suse.com>
> 
> Oh, sorry, I realized that I had forgotten to add:
> Suggested-by: Petr Mladek <pmladek@suse.com>
> 
> Hi Luis:
>   Can you help me add it?

JFYI, I could live without it ;-)

Best Regards,
Petr
