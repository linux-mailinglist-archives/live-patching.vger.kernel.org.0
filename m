Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7731158D
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2019 10:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfEBIjQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 May 2019 04:39:16 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35894 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfEBIjP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 May 2019 04:39:15 -0400
Received: by mail-lf1-f65.google.com with SMTP id u17so1253089lfi.3;
        Thu, 02 May 2019 01:39:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9H3BgZp27P7mZ02Xdw3I95aZVZTQBdCTy/G/xueiXik=;
        b=nYeGkR4fZmRzZYx/+CjyN8vt8N2zjqdITErs5eJI95lz0UJyZd8P5IPbUnMO3jkkcn
         3ErCbhbhBJNZ+7jsoBwcxUDR6Dpo07pRJGvBNPIVuJTRTn5cz0TVwDaM1MUtqWmtqJMd
         uPu9NGunSQ7Oq5UuMHpVUlQI4HTlFcKjO9bH8bgIbM5MLVvChd2i7+UYKmje0jYJiH40
         /4ICpU4YRC1rKItl9Ey6gk3mzdWwIyutF01ZmXtUDr60BiFC7fEtvj8HnerSt0pB9BHx
         3qArNrTLswPY0lhW2sYYNAiLK3uzymCzKRL3ORfJVM8FPBIwvdo+FrU3vnWD7U8lLPc3
         d+bw==
X-Gm-Message-State: APjAAAXNBtwmZWuSDn7mFeFdb+GL2q51LYIe/WjBrEyNBUgmL8A1eL34
        u4sBtarW14FrJ0Lf/iYJRt0=
X-Google-Smtp-Source: APXvYqxz4WgugS9CiMRU6Ex52NCqBvvCTyAbngYF74d1Avin/SP6/y92WlHAmhpIpRXsM4j/eHHuNg==
X-Received: by 2002:a19:a8c8:: with SMTP id r191mr1260548lfe.161.1556786353611;
        Thu, 02 May 2019 01:39:13 -0700 (PDT)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id m15sm556223lfl.54.2019.05.02.01.39.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 01:39:12 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1hM7FS-0001qQ-Gj; Thu, 02 May 2019 10:39:22 +0200
Date:   Thu, 2 May 2019 10:39:22 +0200
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
Message-ID: <20190502083922.GR26546@localhost>
References: <20190502023142.20139-1-tobin@kernel.org>
 <20190502023142.20139-4-tobin@kernel.org>
 <20190502073823.GQ26546@localhost>
 <20190502082539.GB18363@eros.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502082539.GB18363@eros.localdomain>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, May 02, 2019 at 06:25:39PM +1000, Tobin C. Harding wrote: > Adding Jon to CC
> 
> On Thu, May 02, 2019 at 09:38:23AM +0200, Johan Hovold wrote:
> > On Thu, May 02, 2019 at 12:31:40PM +1000, Tobin C. Harding wrote:
> > > kernel-doc comments have a prescribed format.  This includes parenthesis
> > > on the function name.  To be _particularly_ correct we should also
> > > capitalise the brief description and terminate it with a period.
> > 
> > Why do think capitalisation and full stop is required for the function
> > description?
> > 
> > Sure, the example in the current doc happen to use that, but I'm not
> > sure that's intended as a prescription.
> > 
> > The old kernel-doc nano-HOWTO specifically did not use this:
> > 
> > 	https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt
> > 
> 
> Oh?  I was basing this on Documentation/doc-guide/kernel-doc.rst
> 
> 	Function documentation
> 	----------------------
> 
> 	The general format of a function and function-like macro kernel-doc comment is::
> 
> 	  /**
> 	   * function_name() - Brief description of function.
> 	   * @arg1: Describe the first argument.
> 	   * @arg2: Describe the second argument.
> 	   *        One can provide multiple line descriptions
> 	   *        for arguments.
> 
> I figured that was the canonical way to do kernel-doc function
> comments.  I have however refrained from capitalising and adding the
> period to argument strings to reduce code churn.  I figured if I'm
> touching the line to add parenthesis then I might as well make it
> perfect (if such a thing exists).

I think you may have read too much into that example. Many of the
current function and parameter descriptions aren't even full sentences,
so sentence case and full stop doesn't really make any sense.

Looks like we discussed this last fall as well:

	https://lkml.kernel.org/r/20180912093116.GC1089@localhost

Johan
