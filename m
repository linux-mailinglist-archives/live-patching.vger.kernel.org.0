Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFFFD101EA
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 23:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfD3VjL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 17:39:11 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45479 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726155AbfD3VjL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 17:39:11 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 3E4AD236D8;
        Tue, 30 Apr 2019 17:39:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 30 Apr 2019 17:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tobin.cc; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=9349H2ViHXlJUGHErMFiQqJwUGB
        88NDt1/wQq0/Wh3g=; b=ftwZE9ZTpFyvUhV4lztNeU60jZAupgq/Gzep3WCojzQ
        DTfyVawYRrsfEVc9aRrIYwAfmC9GwEU5xkyZmAsiO4SwCF1A4iqTU4zqmWzo/qxf
        2/ezSulz7pmO7ubbYYdkXSCFDEXVcj42pN2wNLc5rF07NNBRuAvl80TyC81iUKky
        Yl6pSA8nCoMPSs3o4uW8WBGd/1wZeJ4w9F+xyeoe1Q2O0DyZiqHTeWk2PcHKD5x6
        YMya3oOogPpU1qdFksEW7W7wrsPCZ3u56Y2u0JSvgcW0El0BNwjbpFnaddPnrGyL
        Zw8YEzi7jUQ1fzQ7qWrdlwTHdvhbi0dFnDpFJlTZGHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9349H2
        ViHXlJUGHErMFiQqJwUGB88NDt1/wQq0/Wh3g=; b=MEebjIxWNESD3EhKg7PEgw
        P5i1zdNuz88T48wwlNUW+aIhTffT/0+wt/vHOzEPrcvCCq5wswLrOT8J7Awhv0OK
        sCy+uOcNKlQszQzhoElYhQiKu1PBLEprOIw/DU/8qTkoEK0aoAvZpvtyj2a7lyNY
        S4gamL6vB9r0fJMANfJ2kr3WuI2qfTcBuwUtlglGH+9ui8dbTEEWzG3R4QVCaqNw
        w487TaYtdJQmCiP4U9VBtdCVArjm9oi5ScOtXLTt8ROCcghtU+/Vvsx7IkUeWGGz
        Ty5cPseDfl3hyWa8/we80enYp3zsIxk0qVT5sA4ZmZB05XfxIDPP/S8sfJiXhrHQ
        ==
X-ME-Sender: <xms:fsDIXBUm9OwT1BRYg0zn4JQcknJGLxy9AvQevYKvncknWvRob0Iubg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieeigddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdduhedmnecujfgurhepfffhvffukfhfgggtuggjofgfsehttdertdfo
    redvnecuhfhrohhmpedfvfhosghinhcuvedrucfjrghrughinhhgfdcuoehmvgesthhosg
    hinhdrtggtqeenucfkphepuddvuddrgeegrddvtdegrddvfeehnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehmvgesthhosghinhdrtggtnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:fsDIXF0KrDD8IpOm3vu1soouyyA6YkD3u69R1efkUf9BMfFNMbPjNQ>
    <xmx:fsDIXIbk9j8F39F1XXoKi1k74hoJLsGRXVZtVL5d1yjeRskzqevxmA>
    <xmx:fsDIXIq69vvCnNGsPhg-qrMPMHUvCCx1aQZ5w9LL8TgoUmRfoOPuMw>
    <xmx:fsDIXGnzNOVNaxq3GNXuRlGJA-PhC5nohY0eXp6kotFLO4sER_3CWw>
Received: from localhost (ppp121-44-204-235.bras1.syd2.internode.on.net [121.44.204.235])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9C008E424F;
        Tue, 30 Apr 2019 17:39:08 -0400 (EDT)
Date:   Wed, 1 May 2019 07:38:27 +1000
From:   "Tobin C. Harding" <me@tobin.cc>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] livepatch: Use correct kobject cleanup function
Message-ID: <20190430213827.GD9454@eros.localdomain>
References: <20190430001534.26246-1-tobin@kernel.org>
 <20190430001534.26246-3-tobin@kernel.org>
 <alpine.LSU.2.21.1904301256550.8507@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1904301256550.8507@pobox.suse.cz>
X-Mailer: Mutt 1.11.4 (2019-03-13)
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 30, 2019 at 01:00:05PM +0200, Miroslav Benes wrote:
> On Tue, 30 Apr 2019, Tobin C. Harding wrote:
> 
> > The correct cleanup function after a call to kobject_init_and_add() has
> > succeeded is kobject_del() _not_ kobject_put().  kobject_del() calls
> > kobject_put().
> > 
> > Use correct cleanup function when removing a kobject.
> > 
> > Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> > ---
> >  kernel/livepatch/core.c | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index 98a7bec41faa..4cce6bb6e073 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -589,9 +589,8 @@ static void __klp_free_funcs(struct klp_object *obj, bool nops_only)
> >  
> >  		list_del(&func->node);
> >  
> > -		/* Might be called from klp_init_patch() error path. */
> 
> Could you leave the comment as is? If I am not mistaken, it is still 
> valid. func->kobj_added check is here exactly because the function may be 
> called as mentioned.

Will put it back in for you on v2

thanks,
Tobin.
