Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0393D11558
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2019 10:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfEBI0U (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 May 2019 04:26:20 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:46699 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbfEBI0U (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 May 2019 04:26:20 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1EC653F35;
        Thu,  2 May 2019 04:26:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 02 May 2019 04:26:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tobin.cc; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Tp7zYftlX2b1Sckh7/4612Lwdc4
        jz92e9l/OmPRxiQI=; b=iuvmBzPf2AeGpsIbNza2NbYpqmtZvcKduI++LSgcwxd
        OZonOWau7E62WjkyT9CJIuo1rhnHjsxGI3rhF8rgAwkFTTAeXt+XE7qgFTR7stmH
        zfa7x8WliZ9JqHJ90MUtmOLHRmxLfvYyYsaATsmMCPXSc/XivFre9wFkRrYDt2rF
        qm3D7Mn851dRih7B7lweLfY2GZL3yitiQAeeqFd6RTpVBZ4ZaOaeoG5vUSRokfRA
        fYyIR1+SnkM5meN0espXWChqmiOrkfRZzQ6g3NP7mwUHzelBFLsdqKal+nd/pR2d
        vdLXmDfFt0OjTutWbcucDi+z1MsDOwP3DPzf32WdJXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Tp7zYf
        tlX2b1Sckh7/4612Lwdc4jz92e9l/OmPRxiQI=; b=N5teTBnrz3Ti2i+Uf58ZWx
        g8P+/NOVURU+PkteTDhfIMl71H/2YqnbFi06fWfY4QIL4aRlgy+fQBbXZTIYgSjS
        9LKbeOkuWxg7rrUZ5ypNVfMJklp+EGcsUJn+jVnIWAQdC1UQ88ErOnt2aTsS4zpO
        NK97Tx+yGKZNokZxMsxCroYQw2sB8q5BdNnwCadQUzGobX2znhN2wYcUMz7eB1we
        WqoXc6gXi+1eJyJ1Pecr/qcx+imoEGmKmdZiqtHjFg0YOwIiXfAuFXoL4aB3IT/+
        QBoELHIJtCcNjBuIDq2XzpzgXZ4Kruw6UkSh4lanqqGXLabPKJ8pdvfwsaX7UViA
        ==
X-ME-Sender: <xms:qqnKXGf_AIiFlGUTQIEpmWvI__zE5XyoJeMcsNs86ksrC-ZCBSndUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieelgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdduhedmnecujfgurhepfffhvffukfhfgggtuggjofgfsehttdertdfo
    redvnecuhfhrohhmpedfvfhosghinhcuvedrucfjrghrughinhhgfdcuoehmvgesthhosg
    hinhdrtggtqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeduvddurdeg
    gedrvddtgedrvdefheenucfrrghrrghmpehmrghilhhfrhhomhepmhgvsehtohgsihhnrd
    gttgenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:qqnKXEzcUnU4L_P7Pat-qIBnmYjaP_ioh1tWQqxTAT4aUh-0g2Ggag>
    <xmx:qqnKXEqUJKX3si3dfMP5nFII_Hv6CqHIvGL1UT3M_kklcoXLuroHug>
    <xmx:qqnKXKwwwVBE15_xc6mSQl7MAiwQFnY5BYUh1BqixG5gEtrkz3RCiQ>
    <xmx:q6nKXEq7Obx0WuoED4OOUbKbMJfR0FCO72XinJZrIFgxeJEU0oza6w>
Received: from localhost (ppp121-44-204-235.bras1.syd2.internode.on.net [121.44.204.235])
        by mail.messagingengine.com (Postfix) with ESMTPA id B2ED7E4382;
        Thu,  2 May 2019 04:26:17 -0400 (EDT)
Date:   Thu, 2 May 2019 18:25:39 +1000
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
Message-ID: <20190502082539.GB18363@eros.localdomain>
References: <20190502023142.20139-1-tobin@kernel.org>
 <20190502023142.20139-4-tobin@kernel.org>
 <20190502073823.GQ26546@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502073823.GQ26546@localhost>
X-Mailer: Mutt 1.11.4 (2019-03-13)
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Adding Jon to CC

On Thu, May 02, 2019 at 09:38:23AM +0200, Johan Hovold wrote:
> On Thu, May 02, 2019 at 12:31:40PM +1000, Tobin C. Harding wrote:
> > kernel-doc comments have a prescribed format.  This includes parenthesis
> > on the function name.  To be _particularly_ correct we should also
> > capitalise the brief description and terminate it with a period.
> 
> Why do think capitalisation and full stop is required for the function
> description?
> 
> Sure, the example in the current doc happen to use that, but I'm not
> sure that's intended as a prescription.
> 
> The old kernel-doc nano-HOWTO specifically did not use this:
> 
> 	https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt
> 

Oh?  I was basing this on Documentation/doc-guide/kernel-doc.rst

	Function documentation
	----------------------

	The general format of a function and function-like macro kernel-doc comment is::

	  /**
	   * function_name() - Brief description of function.
	   * @arg1: Describe the first argument.
	   * @arg2: Describe the second argument.
	   *        One can provide multiple line descriptions
	   *        for arguments.

I figured that was the canonical way to do kernel-doc function
comments.  I have however refrained from capitalising and adding the
period to argument strings to reduce code churn.  I figured if I'm
touching the line to add parenthesis then I might as well make it
perfect (if such a thing exists).

thanks,
Tobin.
