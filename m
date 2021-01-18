Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D16D2F9F6E
	for <lists+live-patching@lfdr.de>; Mon, 18 Jan 2021 13:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391431AbhARMWe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jan 2021 07:22:34 -0500
Received: from foss.arm.com ([217.140.110.172]:34508 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391382AbhARMWb (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jan 2021 07:22:31 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5EC3431B;
        Mon, 18 Jan 2021 04:21:45 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.39.202])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B62633F719;
        Mon, 18 Jan 2021 04:21:42 -0800 (PST)
Date:   Mon, 18 Jan 2021 12:21:35 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Mark Brown <broonie@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-doc@vgert.kernel.org
Subject: Re: [PATCH v3] Documentation: livepatch: document reliable stacktrace
Message-ID: <20210118122135.GA31263@C02TD0UTHF1T.local>
References: <20210115142446.13880-1-broonie@kernel.org>
 <20210115164718.GE44111@C02TD0UTHF1T.local>
 <20210115171251.GF4384@sirena.org.uk>
 <20210115102014.76e51309@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115102014.76e51309@lwn.net>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 15, 2021 at 10:20:14AM -0700, Jonathan Corbet wrote:
> On Fri, 15 Jan 2021 17:12:51 +0000
> Mark Brown <broonie@kernel.org> wrote:
> 
> > On Fri, Jan 15, 2021 at 04:47:18PM +0000, Mark Rutland wrote:
> > > On Fri, Jan 15, 2021 at 02:24:46PM +0000, Mark Brown wrote:  
> > 
> > > > +    3. Considerations
> > > > +       3.1 Identifying successful termination  
> > 
> > > It looks like we forgot to update this with the addition of the new
> > > section 3, so this needs a trivial update to add that and fix the
> > > numbering.  
> > 
> > Bah, I thought the point with structured documentation formats was that
> > tooling would handle stuff like this :/
> 
> The tooling *will* handle it if you let it, it's a simple matter of
> replacing the hand-generated table of contents with a Sphinx directive.  I
> think that's generally the right thing to do, but it does have the
> downside of only putting the TOC in the generated docs.

Ah, I was not aware of that, and I had copied the TOC style from
Documentation/livepatch/livepatch.rst.

That does sound like the right thing to do generally, and I have no
problem doing that here, but I guess we be consistent and either do that
for all or none of the Documentation/livepatch/*.rst documents. I guess
we could do that as a followup?

Thanks,
Mark.
