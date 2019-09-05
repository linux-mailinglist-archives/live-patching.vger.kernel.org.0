Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA79AA122
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 13:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfIELTZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Sep 2019 07:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbfIELTY (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Sep 2019 07:19:24 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 648B321883;
        Thu,  5 Sep 2019 11:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567682363;
        bh=trWSMNdPAGCrEWjjBN4gvX5GSpUep8UtgXKdzyHMgGI=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=OgWjamNnWPljlkWynEYUq06hDNTq6oUnb7qTDfkELOCS8a8E5ovwXwfLwHNjHaflY
         ePkzdy8A+LqrWYziDMGqUJ7bKYtzU7JHOGYvjtDL58Czo+usqCcSITcLj/uRQQzk/m
         paBfn8l8NDTZOVM5vRT2eAao5PwOLMiwQGpll8Nk=
Date:   Thu, 5 Sep 2019 13:19:06 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <20190905110955.wl4lwjbnpqybhkcn@pathway.suse.cz>
Message-ID: <nycvar.YFH.7.76.1909051317550.31470@cbobk.fhfr.pm>
References: <20190814151244.5xoaxib5iya2qjco@treble> <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz> <20190822223649.ptg6e7qyvosrljqx@treble> <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz> <20190826145449.wyo7avwpqyriem46@treble>
 <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz> <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com> <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz> <20190904084932.gndrtewubqiaxmzy@pathway.suse.cz> <20190905025055.36loaatxtkhdo4q5@treble>
 <20190905110955.wl4lwjbnpqybhkcn@pathway.suse.cz>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 5 Sep 2019, Petr Mladek wrote:

> > I don't have a number, but it's very common to patch a function which 
> > uses jump labels or alternatives.
> 
> Really? My impression is that both alternatives and jump_labels
> are used in hot paths. I would expect them mostly in core code
> that is always loaded.
> 
> Alternatives are often used in assembly that we are not able
> to livepatch anyway.
> 
> Or are they spread widely via some macros or inlined functions?

All the indirect jumps are turned into alternatives when retpolines are in 
place.

-- 
Jiri Kosina
SUSE Labs

