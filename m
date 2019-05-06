Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF39B15640
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2019 01:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfEFXBO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 May 2019 19:01:14 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:44413 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726063AbfEFXBN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 May 2019 19:01:13 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 62C22148C8;
        Mon,  6 May 2019 19:01:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 06 May 2019 19:01:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tobin.cc; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=xM4jzc9dPTg4gnuuWc7wADR0BLb
        nKp4nVQ2UXDxHlno=; b=eecXp3dVsf21b/PePO+9dDTmHMKmNs/bczR0WgIq2VG
        oRcW0wnHuFcwqgTLkBMWIcA4vmbfkCFDXcwxugn2eUFF4J9d6Z+AlRlfdgcsQJnN
        t0oaRAkr8nUezQ9K9pwUg92YlLJT1o/oPm3G4C7ZxTv1xLefYcMgTOxGN8eGPa8K
        yGmHEkK468uOfWS4WI8RKJbdXoTuMb3JM840VQuykkGX+W3dnFi3WqHKh4ykadrP
        SXKgKwsZYWk27TuL7M08Umxghaz8zoLnR/YZgaOvcYdEhlvJQz0D/pzRFaTovEI9
        hiM2n3i3QZflDkM4DucwObTdpYIxUCG09zyre/P0m+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xM4jzc
        9dPTg4gnuuWc7wADR0BLbnKp4nVQ2UXDxHlno=; b=DxAdKNqbMrpd1c/MEb2Mzz
        nn25hafBJtjPs3+Tinc9xoNd1VYfIeBmB9EqTU3i2oQIko4Ok9RmxbNJvS+lX6N5
        9ZW0HJHHacAKsuOb332WPdeRAz7p27Tm/4TQhHst0B3dMVcmv2AdpPIY6UB2Egs0
        qQEfJVojB3ilByqTYIG/pIBeA652uTM5FCZnj3dwHVQTqQMOnVvCmxZHG3oTGVmb
        rHXC6mfC7J09GnBYZX9OhpbYD5wrCqqHZtOMpoYpCaZY/QDz4RF0dCFCDFvjplYI
        iAR3XcMFsQaqJanKkxogOUYbE8WacNkjacmAQZupxY8itmmTIpSL9si2V5nKXJFw
        ==
X-ME-Sender: <xms:tLzQXD10ZEomj0bVeUMzj6XLrdNFC0oL0Ek7j6IymvyP8FuOT30AXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrjeelgddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdduhedmnecujfgurhepfffhvffukfhfgggtuggjofgfsehttdertdfo
    redvnecuhfhrohhmpedfvfhosghinhcuvedrucfjrghrughinhhgfdcuoehmvgesthhosg
    hinhdrtggtqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeduvddurdeg
    gedrudelkedrudegudenucfrrghrrghmpehmrghilhhfrhhomhepmhgvsehtohgsihhnrd
    gttgenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:tLzQXEphdkpoC4t8paPfeEJWIV3_MYhQcks3J-y_Cjt0sGqtxmGIPA>
    <xmx:tLzQXLCvZjaJsYGdN52lnTOinc7X84Q1Ho450kOQPqIlo2FEZyR7_g>
    <xmx:tLzQXBG0wQBewtjvTIuiPLppZxhI1vyHqxfW1fEW7ybvfpeSGlfv-g>
    <xmx:trzQXAJanD-b7_V4GWJSPP_KlaZgvoWD8kg4V3M9RsCVIK75ZxIkgw>
Received: from localhost (ppp121-44-198-141.bras1.syd2.internode.on.net [121.44.198.141])
        by mail.messagingengine.com (Postfix) with ESMTPA id CD8FF1037C;
        Mon,  6 May 2019 19:01:07 -0400 (EDT)
Date:   Tue, 7 May 2019 09:00:35 +1000
From:   "Tobin C. Harding" <me@tobin.cc>
To:     Johan Hovold <johan@kernel.org>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/5] kobject: Fix kernel-doc comment first line
Message-ID: <20190506230035.GA29554@eros.localdomain>
References: <20190502023142.20139-1-tobin@kernel.org>
 <20190502023142.20139-4-tobin@kernel.org>
 <20190502073823.GQ26546@localhost>
 <20190502082539.GB18363@eros.localdomain>
 <20190502083922.GR26546@localhost>
 <20190503014015.GC7416@eros.localdomain>
 <20190503075607.GC26546@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503075607.GC26546@localhost>
X-Mailer: Mutt 1.11.4 (2019-03-13)
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 03, 2019 at 09:56:07AM +0200, Johan Hovold wrote:
> On Fri, May 03, 2019 at 11:40:15AM +1000, Tobin C. Harding wrote:
> > On Thu, May 02, 2019 at 10:39:22AM +0200, Johan Hovold wrote:
> > > On Thu, May 02, 2019 at 06:25:39PM +1000, Tobin C. Harding wrote: > Adding Jon to CC
> > > > 
> > > > On Thu, May 02, 2019 at 09:38:23AM +0200, Johan Hovold wrote:
> > > > > On Thu, May 02, 2019 at 12:31:40PM +1000, Tobin C. Harding wrote:
> > > > > > kernel-doc comments have a prescribed format.  This includes parenthesis
> > > > > > on the function name.  To be _particularly_ correct we should also
> > > > > > capitalise the brief description and terminate it with a period.
> > > > > 
> > > > > Why do think capitalisation and full stop is required for the function
> > > > > description?
> > > > > 
> > > > > Sure, the example in the current doc happen to use that, but I'm not
> > > > > sure that's intended as a prescription.
> > > > > 
> > > > > The old kernel-doc nano-HOWTO specifically did not use this:
> > > > > 
> > > > > 	https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt
> > > > > 
> > > > 
> > > > Oh?  I was basing this on Documentation/doc-guide/kernel-doc.rst
> > > > 
> > > > 	Function documentation
> > > > 	----------------------
> > > > 
> > > > 	The general format of a function and function-like macro kernel-doc comment is::
> > > > 
> > > > 	  /**
> > > > 	   * function_name() - Brief description of function.
> > > > 	   * @arg1: Describe the first argument.
> > > > 	   * @arg2: Describe the second argument.
> > > > 	   *        One can provide multiple line descriptions
> > > > 	   *        for arguments.
> > > > 
> > > > I figured that was the canonical way to do kernel-doc function
> > > > comments.  I have however refrained from capitalising and adding the
> > > > period to argument strings to reduce code churn.  I figured if I'm
> > > > touching the line to add parenthesis then I might as well make it
> > > > perfect (if such a thing exists).
> > >
> > > I think you may have read too much into that example. Many of the
> > > current function and parameter descriptions aren't even full sentences,
> > > so sentence case and full stop doesn't really make any sense.
> > >
> > > Looks like we discussed this last fall as well:
> > 
> > Ha, this was funny.  By 'we' at first I thought you meant 'we the kernel
> > community' but you actually meant we as in 'me and you'.  Clearly you
> > failed to convince me last time :)
> > 
> > > 	https://lkml.kernel.org/r/20180912093116.GC1089@localhost
> > 
> > I am totally aware this is close to code churn and any discussion is
> > bikeshedding ... for me just because loads of places don't do this it
> > still looks nicer to my eyes
> > 
> > /**
> > * sfn() - Super awesome function.
> > 
> > than
> > 
> > /**
> > */ sfn() - super awesome function
> > 
> > I most likely will keep doing these changes if I am touching the
> > kernel-doc comments for other reasons and then drop the changes if the
> > subsystem maintainer thinks its code churn.
> > 
> > I defiantly won't do theses changes in GNSS, GREYBUS, or USB SERIAL.
> 
> This isn't about any particular subsystem, but more the tendency of
> people to make up random rules and try to to force it on others. It's
> churn, and also makes things like code forensics and backports harder
> for no good reason.

Points noted.

> Both capitalisation styles are about as common for the function
> description judging from a quick grep, but only 10% or so use a full
> stop ('.'). And forcing the use of sentence case and full stop for
> things like
> 
> 	/**
> 	 * maar_init() - Initialise MAARs.
> 
> or
> 
> 	* @instr: Operational instruction.
> 
> would be not just ugly, but wrong (as these are not independent
> clauses).

You are correct here.

Thanks for taking the time to flesh out your argument Johan, I am now in
agreement with you :)

Cheers,
Tobin.
