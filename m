Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89002FA3CB
	for <lists+live-patching@lfdr.de>; Mon, 18 Jan 2021 15:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405319AbhARO4j (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jan 2021 09:56:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405441AbhARO4P (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jan 2021 09:56:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610981689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a4fFJIs4FEO7n3SaQ79hr7vT0S2c5hk6pQH7CBXK3TE=;
        b=Oms7rQuP6so+hY6vGQUEKe0jFUblBPgv2Pac8exKDpeHkb5i4M9vReTECcifvqfn1YIBgh
        d+lJXY0WbAki/5TYhF7nHfQVs6rzhsbBEYE3eko4njAK/ZOemkOLl/QDG1Ex+AFPvpycoz
        zYo3XtFH6OBDNVPuL0P8iDX9He3M5QE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-PQIg1cB-NZ6yTiczm6emCg-1; Mon, 18 Jan 2021 09:54:45 -0500
X-MC-Unique: PQIg1cB-NZ6yTiczm6emCg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89217806664;
        Mon, 18 Jan 2021 14:54:43 +0000 (UTC)
Received: from treble (ovpn-116-102.rdu2.redhat.com [10.10.116.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4089118038;
        Mon, 18 Jan 2021 14:54:38 +0000 (UTC)
Date:   Mon, 18 Jan 2021 08:54:36 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Miroslav Benes <mbenes@suse.cz>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v4] Documentation: livepatch: document reliable stacktrace
Message-ID: <20210118145436.3qceoxtn7rl2yllg@treble>
References: <20210115171617.47273-1-broonie@kernel.org>
 <YAWU0D50KH4mVTgn@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YAWU0D50KH4mVTgn@alley>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jan 18, 2021 at 03:02:31PM +0100, Petr Mladek wrote:
> Hi Mark,
> 
> first, thanks a lot for writing this.
> 
> On Fri 2021-01-15 17:16:17, Mark Brown wrote:
> > From: Mark Rutland <mark.rutland@arm.com>
> > 
> > Add documentation for reliable stacktrace. This is intended to describe
> > the semantics and to be an aid for implementing architecture support for
> > HAVE_RELIABLE_STACKTRACE.
> > 
> > Unwinding is a subtle area, and architectures vary greatly in both
> > implementation and the set of concerns that affect them, so I've tried
> > to avoid making this too specific to any given architecture. I've used
> > examples from both x86_64 and arm64 to explain corner cases in more
> > detail, but I've tried to keep the descriptions sufficient for those who
> > are unfamiliar with the particular architecture.
> >
> > I've tried to give rationale for all the recommendations/requirements,
> > since that makes it easier to spot nearby issues, or when a check
> > happens to catch a few things at once.
> 
> The above looks enough for the commit message. Well, Josh, typically
> asks for a directive style, example:
> 
> Instead of "I've tried to give rationale...", please use something like
> "The documentation gives rationale...".

True, we do try to use imperative form like "Try to give rationale...".

Though documentation is less technical than code, so maybe technical
language is less important.

> > I believe what I have written is
> > sound, but as some of this was reverse-engineered I may have missed
> > things worth noting.
> > 
> > I've made a few assumptions about preferred behaviour, notably:
> > 
> > * If you can reliably unwind through exceptions, you should (as x86_64
> >   does).
> > 
> > * It's fine to omit ftrace_return_to_handler and other return
> >   trampolines so long as these are not subject to patching and the
> >   original return address is reported. Most architectures do this for
> >   ftrace_return_handler, but not other return trampolines.
> > 
> > * For cases where link register unreliability could result in duplicate
> >   entries in the trace or an inverted trace, I've assumed this should be
> >   treated as unreliable. This specific case shouldn't matter to
> >   livepatching, but I assume that that we want a reliable trace to have
> >   the correct order.
> 
> This looks like a background that is typically part of the cover
> leter. It mentions some Mark's doubts.
> 
> Could anyone please answer whether the above assumptions are correct
> or not? We should remove them from the commit message. If any
> assumption is wrong, we should fix the documentation.

Agreed, this section can probably be dropped.

-- 
Josh

