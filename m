Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199BC2F8214
	for <lists+live-patching@lfdr.de>; Fri, 15 Jan 2021 18:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbhAORVh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Jan 2021 12:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbhAORVg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Jan 2021 12:21:36 -0500
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10A1C061757
        for <live-patching@vger.kernel.org>; Fri, 15 Jan 2021 09:20:56 -0800 (PST)
Received: from lwn.net (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 70EC26144;
        Fri, 15 Jan 2021 17:20:15 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 70EC26144
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1610731215; bh=oqtY8FiVdPzSIv0x1ovYAKgJlnLzyaUv/KHtQfpJhDU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HgJpJDItOsE06j+N7/+v5CzKXdhMg+fmiAp+75mQuLLAEo4XtBRu9XfzZ8wZZr8Wj
         4cgyjc29cdWDsZoRQDfZotmkLJgQvcDzSzZfdLcq8EtC8NdcPncQwJ/X5fj0a7rx9C
         DOWTA5HRPxEk3wubj8BGe4ru76bpYx43A7XPud2tYowdjfNg+6CQ9vwz+xfaZLORjI
         hfuDIyKlUax/4rnsS/K2sfrb80qrXVmlgE/LFcrPL6cerBjn1fC4OF4nN6AIJ/bO2m
         4uBnGkTLXCP26Xn7RktdLtnLJ6aSvdkgC7Fyp2OhvG70adg1O5zeuxcOFETJCA1u+U
         B+vv4YTqYjBTg==
Date:   Fri, 15 Jan 2021 10:20:14 -0700
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mark Brown <broonie@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-doc@vgert.kernel.org
Subject: Re: [PATCH v3] Documentation: livepatch: document reliable
 stacktrace
Message-ID: <20210115102014.76e51309@lwn.net>
In-Reply-To: <20210115171251.GF4384@sirena.org.uk>
References: <20210115142446.13880-1-broonie@kernel.org>
        <20210115164718.GE44111@C02TD0UTHF1T.local>
        <20210115171251.GF4384@sirena.org.uk>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 15 Jan 2021 17:12:51 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Fri, Jan 15, 2021 at 04:47:18PM +0000, Mark Rutland wrote:
> > On Fri, Jan 15, 2021 at 02:24:46PM +0000, Mark Brown wrote:  
> 
> > > +    3. Considerations
> > > +       3.1 Identifying successful termination  
> 
> > It looks like we forgot to update this with the addition of the new
> > section 3, so this needs a trivial update to add that and fix the
> > numbering.  
> 
> Bah, I thought the point with structured documentation formats was that
> tooling would handle stuff like this :/

The tooling *will* handle it if you let it, it's a simple matter of
replacing the hand-generated table of contents with a Sphinx directive.  I
think that's generally the right thing to do, but it does have the
downside of only putting the TOC in the generated docs.

Thanks,

jon
