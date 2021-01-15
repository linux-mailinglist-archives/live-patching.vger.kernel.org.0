Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178232F7F4E
	for <lists+live-patching@lfdr.de>; Fri, 15 Jan 2021 16:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbhAOPSJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Jan 2021 10:18:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45013 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732208AbhAOPSI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Jan 2021 10:18:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610723802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gk/kn7jsUx99go9pXyOS699OdqvAXfBJlm34KUBZcPw=;
        b=H5b2n3RznmWlhoL0MgybKOfU2eXp3dRC1VqH581RVWH0wNpkuXdaZ+M87n9oVJBoR1t01z
        aE+7W6u/4OS1Bkf/F0eLwFltgPTiAmJ2oaiUFHjvtOytxdR4956eLD11MSCOxzQk9I8lFp
        PPqvqgb2o94fla4Qt7HjCTVVrRNUNXI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-e0qZgkjYP_idxDLrqEdSaA-1; Fri, 15 Jan 2021 10:16:40 -0500
X-MC-Unique: e0qZgkjYP_idxDLrqEdSaA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDD4A1005D44;
        Fri, 15 Jan 2021 15:16:38 +0000 (UTC)
Received: from treble (ovpn-116-102.rdu2.redhat.com [10.10.116.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CDF5D19C45;
        Fri, 15 Jan 2021 15:16:34 +0000 (UTC)
Date:   Fri, 15 Jan 2021 09:16:32 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3] Documentation: livepatch: document reliable stacktrace
Message-ID: <20210115151609.lqrl2yuy2zvrcm47@treble>
References: <20210115142446.13880-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210115142446.13880-1-broonie@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 15, 2021 at 02:24:46PM +0000, Mark Brown wrote:
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
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Joe Lawrence <joe.lawrence@redhat.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Miroslav Benes <mbenes@suse.cz>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: linux-doc@vgert.kernel.org
> Cc: live-patching@vger.kernel.org
> [Updates following review -- broonie]
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> 
> v3:
>  - Incorporated objtool section from Mark.
>  - Deleted confusing notes about using annotations.

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh

