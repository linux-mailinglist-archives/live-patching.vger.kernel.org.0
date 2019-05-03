Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9741297D
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2019 10:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbfECIFm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 May 2019 04:05:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:57366 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725798AbfECIFm (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 May 2019 04:05:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CFD26AC4F;
        Fri,  3 May 2019 08:05:40 +0000 (UTC)
Date:   Fri, 3 May 2019 10:05:40 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     "Tobin C. Harding" <me@tobin.cc>,
        "Tobin C. Harding" <tobin@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/5] kobject: Fix kernel-doc comment first line
Message-ID: <20190503080540.4ar5adqmo2c5yh5n@pathway.suse.cz>
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
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2019-05-03 09:56:07, Johan Hovold wrote:
> On Fri, May 03, 2019 at 11:40:15AM +1000, Tobin C. Harding wrote:
> > On Thu, May 02, 2019 at 10:39:22AM +0200, Johan Hovold wrote:
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

+1

But I could understand that it is hard to keep it as is when it bothers
ones eyes. I tend to change these things as well and have to activelly
stop myself again and again ;-)

Best Regards,
Petr
