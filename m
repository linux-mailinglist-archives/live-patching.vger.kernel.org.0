Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C204648C30
	for <lists+live-patching@lfdr.de>; Sat, 10 Dec 2022 02:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiLJBJt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Dec 2022 20:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLJBJs (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Dec 2022 20:09:48 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CB7F010;
        Fri,  9 Dec 2022 17:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MUb4yQoHyZ6YBjsxLLL/BLZnhDgIi+qZpS97jRSQv/s=; b=RyB09IfH8GMuhNGE4qhj3s11XX
        Gh48husrdvAU3Nq/AusbekicUXfnBsLWplnp3iq8CH/Q6NYDXhPtP5EZUphDlpbmZ/sH6d2VplG/9
        nK/LAAqwsagN7OXoCAcL7SiyiTJB1GVMAsH4BZm3YQdG+JQ2Aa1J4XC53KSa9Pm5U4XulnbLaQcD5
        VnKQ1Lksb2zdm5MlPcidD3yjZgQ/J2xCTgzjEKNOQwu5P2KrRMHOW41FAfn/sIxp4v2LeK0ZpBXip
        00gUhC537DhMlOCiO0BQIyzw3Yj+bPUkViRV9qrlfjxllKyrnm0Pso+eGHsf0O1ftJnN+skBMIfRr
        v298eRdQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p3oN0-00CzOy-0z; Sat, 10 Dec 2022 01:09:38 +0000
Date:   Fri, 9 Dec 2022 17:09:37 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-modules@vger.kernel.org
Subject: Re: [PATCH] livepatch: Call klp_match_callback() in
 klp_find_callback() to avoid code duplication
Message-ID: <Y5PcUYXGY4ct/FXL@bombadil.infradead.org>
References: <20221207032304.2017-1-thunder.leizhen@huawei.com>
 <Y5L75x+W1NrWCOcm@alley>
 <aed3ca41-0f27-b44e-b95c-f7ed0a8ef468@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aed3ca41-0f27-b44e-b95c-f7ed0a8ef468@huawei.com>
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

On Fri, Dec 09, 2022 at 07:29:56PM +0800, Leizhen (ThunderTown) wrote:
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

Done!

  Luis
