Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 312D5101DF
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 23:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfD3ViM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 17:38:12 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60781 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726048AbfD3ViM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 17:38:12 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 489E423075;
        Tue, 30 Apr 2019 17:38:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 30 Apr 2019 17:38:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tobin.cc; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=z/wot53dADMViIAkfdEWPVrOhYU
        SuTUgxPTfH7rwG3I=; b=ihfnKxtkM8dC5o+KzimVK+qfTuDO0q2coXzeoit84DY
        uFVU0L8GkxgZH8P3Pis38k699KtYwBWLk18s1c6G1HGeeUYqGCeh1fRhz1kOlHXI
        tSpKiId4Fn5IJ7GBOiV1scXvmHlYfrD+StLjin+KcJcxAX/8MsgmWRifYs3zWqab
        TOp74PSP/XjQBP1GQod+uh+r54AfYsK2gGGpyWn4eDAuWOrsdir/qI8tRgS0EUj7
        9SG15Ad0veTG1BrIrfLgICrPfyN6g6BvX/hm/TBVa68B5ZUXu7R+CBQI8wqAIwJE
        lml0ME09qN/FJKtcS6z96+3Wk5n4tcp5GUyP4lC2QrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=z/wot5
        3dADMViIAkfdEWPVrOhYUSuTUgxPTfH7rwG3I=; b=N5MhjEuKkADRg2xBbcgrpz
        730hK4VfLVFlEr1OTVxUJ7gBwCv97y9UvUokzHx9v0FUNGO6i7xyl0q1yBpP48+K
        1a+yTxLa8vUSY3P2hWqYE7WxWf8T6+bD7HE8K8I3M0Ym12G+r6ew5uFWKRiKLOwn
        FCMO6wSugoAP7MM2PCi6lf/a6NXozEDW439vkG4/Dctdax/Y/1RO4IHPx5Gj+4PS
        e6dA6vrD7zF2wVPYuU/eKMfP0sapfneh/t/4tS3Xn/qfPPGlvWcYo9obqGrcpJq0
        dAfA2/Hx58yaitOPzMWz7cQKuI9YBC2tALvrz/g7L51pWFLzeDgDZuqR3EfoPwGA
        ==
X-ME-Sender: <xms:QsDIXJ2dxTMClk89e3Buei1Q-5L00jmt4FotNQXm_PFKjAbNSabTXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieeigddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdeftddmnecujfgurhepfffhvffukfhfgggtuggjofgfsehttdertdfo
    redvnecuhfhrohhmpedfvfhosghinhcuvedrucfjrghrughinhhgfdcuoehmvgesthhosg
    hinhdrtggtqeenucfkphepuddvuddrgeegrddvtdegrddvfeehnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehmvgesthhosghinhdrtggtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:QsDIXIHJ7uplv-AU9I6i8_Ism9pcqyvsYVLgajweymZDu4bBIFh2Ag>
    <xmx:QsDIXKiHXmMxc69XlsC8t1gCBEJE6AchJ-8Ok1hf_ZGT6ykb6-hbrg>
    <xmx:QsDIXGbl7Zi_-lRftJfCoi1fYgSSheW-Qt1E2KsQQ0pvR2Pvy99NAg>
    <xmx:Q8DIXMqXyeRft_XnONG1OJgJ5qXqhCCAZZu9kHsEWBUyxFQqdipl1A>
Received: from localhost (ppp121-44-204-235.bras1.syd2.internode.on.net [121.44.204.235])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1BB03103CD;
        Tue, 30 Apr 2019 17:38:09 -0400 (EDT)
Date:   Wed, 1 May 2019 07:37:30 +1000
From:   "Tobin C. Harding" <me@tobin.cc>
To:     Petr Mladek <pmladek@suse.com>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] livepatch: Use correct kobject cleanup function
Message-ID: <20190430213730.GC9454@eros.localdomain>
References: <20190430001534.26246-1-tobin@kernel.org>
 <20190430001534.26246-3-tobin@kernel.org>
 <20190430150811.4hzhtz4w46o6numh@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430150811.4hzhtz4w46o6numh@pathway.suse.cz>
X-Mailer: Mutt 1.11.4 (2019-03-13)
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 30, 2019 at 05:08:11PM +0200, Petr Mladek wrote:
> On Tue 2019-04-30 10:15:34, Tobin C. Harding wrote:
> > The correct cleanup function after a call to kobject_init_and_add() has
> > succeeded is kobject_del() _not_ kobject_put().  kobject_del() calls
> > kobject_put().
> 
> Really? I see only kobject_put(kobj->parent) in kobject_del.
> It decreases a reference of the _parent_ object and not
> the given one.

Thanks Petr, you are right.  I misread kobject_del().  The story
thickens, so we need to call kobject_del() AND kobject_put().

> Also the section "Kobject removal" in Documentation/kobject.txt
> says that kobject_del() is for two-stage removal. kobject_put()
> still needs to get called at a later time.

Is this call sequence above what is meant by 'two-stage removal', I
didn't really understand that bit of the docs (and I almost always just
assume docs are stale and take them as a hint only :)

> IMHO, this patch causes that kobject_put() would never get called.

I'll do a v2 of this one and re-check all the patches on this I've
already sent (including the docs ones).

> That said, we could probably make the removal a bit cleaner
> by using kobject_del() in klp_free_patch_start() and
> kobject_put() in klp_free_patch_finish(). But I have
> to think more about it.

Noted, thanks for your review.

	Tobin
	
