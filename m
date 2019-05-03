Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEBA12923
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2019 09:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfECHz6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 May 2019 03:55:58 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36113 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfECHz6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 May 2019 03:55:58 -0400
Received: by mail-lj1-f195.google.com with SMTP id y8so4252811ljd.3;
        Fri, 03 May 2019 00:55:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jg7UCnx31PjlLcCQ+wH+UcUuN001R3UUaiuZHRMbLuw=;
        b=uLBVrkUZjDOaLDsGBXo8i9fqwofD/IavFiSnIErA7R2IacnOiA/5UnEQ9/umL8/Qa6
         lpHpj6BPj2my/z9ZtEPmYPVEwZ+YspFa77HIFttOhJIY7PADxIjytqkpE9/84A4FRYXQ
         Di3NxlPeDarpkS6SQVmXSH1SF6VoC2BOw8+fjsh67NO4GU03LSjfbT4h48MD9kOO13Er
         hCsU37+YXnWMTlCOrzTpvWf4XP2zB4C32OUKrg50WpDuuYIMCinmiJcke1KfAQTXC3z9
         p+4n34ZeDYGzMqClBZ9J//IRORqytZtfKHq8fX6PmMJrNBt91QRofhPRiQjCVdOGgPb9
         xuhg==
X-Gm-Message-State: APjAAAWs8cf2rOuv4j8yRpKiHjWohdayXQLRE8JEW68imTxgDTZKBVLP
        /l6TDQaNnTfV5n4UP9npPjU=
X-Google-Smtp-Source: APXvYqwvxjASXrpe81U574Nq7OeeJHcfRF1tR+491A7KPmFa2CxowftZ2jlXJUNPFGV3Xg6nxoSITA==
X-Received: by 2002:a2e:9094:: with SMTP id l20mr4323814ljg.60.1556870156361;
        Fri, 03 May 2019 00:55:56 -0700 (PDT)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id d16sm279487lfi.75.2019.05.03.00.55.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 00:55:55 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1hMT39-0006LG-Ja; Fri, 03 May 2019 09:56:07 +0200
Date:   Fri, 3 May 2019 09:56:07 +0200
From:   Johan Hovold <johan@kernel.org>
To:     "Tobin C. Harding" <me@tobin.cc>
Cc:     Johan Hovold <johan@kernel.org>,
        "Tobin C. Harding" <tobin@kernel.org>,
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
Message-ID: <20190503075607.GC26546@localhost>
References: <20190502023142.20139-1-tobin@kernel.org>
 <20190502023142.20139-4-tobin@kernel.org>
 <20190502073823.GQ26546@localhost>
 <20190502082539.GB18363@eros.localdomain>
 <20190502083922.GR26546@localhost>
 <20190503014015.GC7416@eros.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503014015.GC7416@eros.localdomain>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 03, 2019 at 11:40:15AM +1000, Tobin C. Harding wrote:
> On Thu, May 02, 2019 at 10:39:22AM +0200, Johan Hovold wrote:
> > On Thu, May 02, 2019 at 06:25:39PM +1000, Tobin C. Harding wrote: > Adding Jon to CC
> > > 
> > > On Thu, May 02, 2019 at 09:38:23AM +0200, Johan Hovold wrote:
> > > > On Thu, May 02, 2019 at 12:31:40PM +1000, Tobin C. Harding wrote:
> > > > > kernel-doc comments have a prescribed format.  This includes parenthesis
> > > > > on the function name.  To be _particularly_ correct we should also
> > > > > capitalise the brief description and terminate it with a period.
> > > > 
> > > > Why do think capitalisation and full stop is required for the function
> > > > description?
> > > > 
> > > > Sure, the example in the current doc happen to use that, but I'm not
> > > > sure that's intended as a prescription.
> > > > 
> > > > The old kernel-doc nano-HOWTO specifically did not use this:
> > > > 
> > > > 	https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt
> > > > 
> > > 
> > > Oh?  I was basing this on Documentation/doc-guide/kernel-doc.rst
> > > 
> > > 	Function documentation
> > > 	----------------------
> > > 
> > > 	The general format of a function and function-like macro kernel-doc comment is::
> > > 
> > > 	  /**
> > > 	   * function_name() - Brief description of function.
> > > 	   * @arg1: Describe the first argument.
> > > 	   * @arg2: Describe the second argument.
> > > 	   *        One can provide multiple line descriptions
> > > 	   *        for arguments.
> > > 
> > > I figured that was the canonical way to do kernel-doc function
> > > comments.  I have however refrained from capitalising and adding the
> > > period to argument strings to reduce code churn.  I figured if I'm
> > > touching the line to add parenthesis then I might as well make it
> > > perfect (if such a thing exists).
> >
> > I think you may have read too much into that example. Many of the
> > current function and parameter descriptions aren't even full sentences,
> > so sentence case and full stop doesn't really make any sense.
> >
> > Looks like we discussed this last fall as well:
> 
> Ha, this was funny.  By 'we' at first I thought you meant 'we the kernel
> community' but you actually meant we as in 'me and you'.  Clearly you
> failed to convince me last time :)
> 
> > 	https://lkml.kernel.org/r/20180912093116.GC1089@localhost
> 
> I am totally aware this is close to code churn and any discussion is
> bikeshedding ... for me just because loads of places don't do this it
> still looks nicer to my eyes
> 
> /**
> * sfn() - Super awesome function.
> 
> than
> 
> /**
> */ sfn() - super awesome function
> 
> I most likely will keep doing these changes if I am touching the
> kernel-doc comments for other reasons and then drop the changes if the
> subsystem maintainer thinks its code churn.
> 
> I defiantly won't do theses changes in GNSS, GREYBUS, or USB SERIAL.

This isn't about any particular subsystem, but more the tendency of
people to make up random rules and try to to force it on others. It's
churn, and also makes things like code forensics and backports harder
for no good reason.

Both capitalisation styles are about as common for the function
description judging from a quick grep, but only 10% or so use a full
stop ('.'). And forcing the use of sentence case and full stop for
things like

	/**
	 * maar_init() - Initialise MAARs.

or

	* @instr: Operational instruction.

would be not just ugly, but wrong (as these are not independent
clauses).

Johan
