Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B0B2F57BA
	for <lists+live-patching@lfdr.de>; Thu, 14 Jan 2021 04:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbhANCF1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 13 Jan 2021 21:05:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32782 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729334AbhAMW12 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 13 Jan 2021 17:27:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610576760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=keqTD1feRGxMu1i6ZV8LKC0UZKTn6b0VdBTOntJphMk=;
        b=YvgwSAuMoKKNc/wzO6ASNlHW6OQXC62NWx28B0MchYpsw1UQ/aMsBjOZ7ijaKFUpgF07Hz
        HfVev1UnXb4JakXPWcl4ButZ2eCXYTB7vwb1iMwGV3b46b1hcGLZMuUKbFOQGpurjzHs19
        Ba0uqUyyLHaQyBLmp7aNSaT8p1nVsgk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-j1KIj2juPlK1m70KZ2kQIQ-1; Wed, 13 Jan 2021 17:25:55 -0500
X-MC-Unique: j1KIj2juPlK1m70KZ2kQIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9754C1060B08;
        Wed, 13 Jan 2021 22:25:47 +0000 (UTC)
Received: from treble (ovpn-120-156.rdu2.redhat.com [10.10.120.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 36A425D71D;
        Wed, 13 Jan 2021 22:25:45 +0000 (UTC)
Date:   Wed, 13 Jan 2021 16:25:41 -0600
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
Message-ID: <20210113222541.ysvtievx4o5r42ym@treble>
References: <20210113165743.3385-1-broonie@kernel.org>
 <20210113192735.rg2fxwlfrzueinci@treble>
 <20210113202315.GI4641@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210113202315.GI4641@sirena.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 13, 2021 at 08:23:15PM +0000, Mark Brown wrote:
> On Wed, Jan 13, 2021 at 01:33:13PM -0600, Josh Poimboeuf wrote:
> 
> > I think it's worth mentioning a little more about objtool.  There are a
> > few passing mentions of objtool's generation of metadata (i.e. ORC), but
> > objtool has another relevant purpose: stack validation.  That's
> > particularly important when it comes to frame pointers.
> 
> > For some architectures like x86_64 and arm64 (but not powerpc/s390),
> > it's far too easy for a human to write asm and/or inline asm which
> > violates frame pointer protocol, silently causing the violater's callee
> > to get skipped in the unwind.  Such architectures need objtool
> > implemented for CONFIG_STACK_VALIDATION.
> 
> This basically boils down to just adding a statement saying "you may
> need to depend on objtool" I think?

Right, but maybe it would be a short paragraph or two.

> > > +There are several ways an architecture may identify kernel code which is deemed
> > > +unreliable to unwind from, e.g.
> 
> > > +* Using metadata created by objtool, with such code annotated with
> > > +  SYM_CODE_{START,END} or STACKFRAME_NON_STANDARD().
> 
> > I'm not sure why SYM_CODE_{START,END} is mentioned here, but it doesn't
> > necessarily mean the code is unreliable, and objtool doesn't treat it as
> > such.  Its mention can probably be removed unless there was some other
> > point I'm missing.
> 
> I was reading that as being a thing that the architecture could possibly
> do, especially as a first step - it does seem like a reasonable thing to
> consider using anyway.  I guess you could also use it the other way
> around and do additional checks for things that are supposed to be
> regular functions that you relax for SYM_CODE() sections.

Makes sense, but we have to be careful not to imply that objtool already
does something like that :-)

-- 
Josh

