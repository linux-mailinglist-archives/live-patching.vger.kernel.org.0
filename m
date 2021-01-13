Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4002F536A
	for <lists+live-patching@lfdr.de>; Wed, 13 Jan 2021 20:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbhAMTex (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 13 Jan 2021 14:34:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45518 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727860AbhAMTew (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 13 Jan 2021 14:34:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610566406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BvxbEyyhBtCq7uGHAUkz6B6eLyqDhX07ZV2UU6Kj9M4=;
        b=LdimAM2cuD2womkMDjEHvo0BkgGZhbpbIESSe9EDsz1o7HfmJJvFeH1MBuT2Q/a8r+QxBM
        KwJSOecU5rQJqUERAvChMtnUyH97oZp/YsRwyhDbghi62PAWYjkNUlZ2zHdFfuUr+lWVx4
        0VhLTSqnR5XNg9R6M4wDsxv5veyYpFY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-TdjqVTxnO4mYhvHFaR1sXw-1; Wed, 13 Jan 2021 14:33:22 -0500
X-MC-Unique: TdjqVTxnO4mYhvHFaR1sXw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B36F8799F8;
        Wed, 13 Jan 2021 19:33:20 +0000 (UTC)
Received: from treble (ovpn-120-156.rdu2.redhat.com [10.10.120.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8411B5D9DD;
        Wed, 13 Jan 2021 19:33:15 +0000 (UTC)
Date:   Wed, 13 Jan 2021 13:33:13 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH] Documentation: livepatch: document reliable stacktrace
Message-ID: <20210113192735.rg2fxwlfrzueinci@treble>
References: <20210113165743.3385-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210113165743.3385-1-broonie@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 13, 2021 at 04:57:43PM +0000, Mark Brown wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> Add documentation for reliable stacktrace. This is intended to describe
> the semantics and to be an aid for implementing architecture support for
> HAVE_RELIABLE_STACKTRACE.
> 
> Unwinding is a subtle area, and architectures vary greatly in both
> implementation and the set of concerns that affect them, so I've tried
> to avoid making this too specific to any given architecture. I've used
> examples from both x86_64 and arm64 to explain corner cases in more
> detail, but I've tried to keep the descriptions sufficient for those who
> are unfamiliar with the particular architecture.
> 
> I've tried to give rationale for all the recommendations/requirements,
> since that makes it easier to spot nearby issues, or when a check
> happens to catch a few things at once. I believe what I have written is
> sound, but as some of this was reverse-engineered I may have missed
> things worth noting.
> 
> I've made a few assumptions about preferred behaviour, notably:
> 
> * If you can reliably unwind through exceptions, you should (as x86_64
>   does).
> 
> * It's fine to omit ftrace_return_to_handler and other return
>   trampolines so long as these are not subject to patching and the
>   original return address is reported. Most architectures do this for
>   ftrace_return_handler, but not other return trampolines.
> 
> * For cases where link register unreliability could result in duplicate
>   entries in the trace or an inverted trace, I've assumed this should be
>   treated as unreliable. This specific case shouldn't matter to
>   livepatching, but I assume that that we want a reliable trace to have
>   the correct order.

Thanks to you and Mark for getting this documented properly!

I think it's worth mentioning a little more about objtool.  There are a
few passing mentions of objtool's generation of metadata (i.e. ORC), but
objtool has another relevant purpose: stack validation.  That's
particularly important when it comes to frame pointers.

For some architectures like x86_64 and arm64 (but not powerpc/s390),
it's far too easy for a human to write asm and/or inline asm which
violates frame pointer protocol, silently causing the violater's callee
to get skipped in the unwind.  Such architectures need objtool
implemented for CONFIG_STACK_VALIDATION.

> +There are several ways an architecture may identify kernel code which is deemed
> +unreliable to unwind from, e.g.
> +
> +* Using metadata created by objtool, with such code annotated with
> +  SYM_CODE_{START,END} or STACKFRAME_NON_STANDARD().

I'm not sure why SYM_CODE_{START,END} is mentioned here, but it doesn't
necessarily mean the code is unreliable, and objtool doesn't treat it as
such.  Its mention can probably be removed unless there was some other
point I'm missing.

Also, s/STACKFRAME/STACK_FRAME/

-- 
Josh

