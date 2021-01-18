Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A342FA7F1
	for <lists+live-patching@lfdr.de>; Mon, 18 Jan 2021 18:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406081AbhARRwV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jan 2021 12:52:21 -0500
Received: from foss.arm.com ([217.140.110.172]:40148 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbhARRvo (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jan 2021 12:51:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FAD631B;
        Mon, 18 Jan 2021 09:50:58 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.39.202])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC8753F719;
        Mon, 18 Jan 2021 09:50:56 -0800 (PST)
Date:   Mon, 18 Jan 2021 17:50:54 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Miroslav Benes <mbenes@suse.cz>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v4] Documentation: livepatch: document reliable stacktrace
Message-ID: <20210118175054.GB38844@C02TD0UTHF1T.local>
References: <20210115171617.47273-1-broonie@kernel.org>
 <YAWU0D50KH4mVTgn@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAWU0D50KH4mVTgn@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Petr,

On Mon, Jan 18, 2021 at 03:02:31PM +0100, Petr Mladek wrote:
> On Fri 2021-01-15 17:16:17, Mark Brown wrote:
> > I've made a few assumptions about preferred behaviour, notably:
> > 
> > * If you can reliably unwind through exceptions, you should (as x86_64
> >   does).

IIRC this was confirmed as desireable, and the text already reflects
this.

> > * It's fine to omit ftrace_return_to_handler and other return
> >   trampolines so long as these are not subject to patching and the
> >   original return address is reported. Most architectures do this for
> >   ftrace_return_handler, but not other return trampolines.

Likewise I think we agreed this was fine, given these were not
themselves subkect to patching.

> > * For cases where link register unreliability could result in duplicate
> >   entries in the trace or an inverted trace, I've assumed this should be
> >   treated as unreliable. This specific case shouldn't matter to
> >   livepatching, but I assume that that we want a reliable trace to have
> >   the correct order.

I don't think we had any comments either way on this, but I think it's
sane to say this for now and later relax it if we need to.

... so I reckon we can just delete all this as Josh suggests. Any acks
for the patch itself tacitly agrees with these points. :)

Thanks,
Mark.
