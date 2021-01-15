Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F50E2F6F3B
	for <lists+live-patching@lfdr.de>; Fri, 15 Jan 2021 01:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731139AbhAOAFi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Jan 2021 19:05:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26781 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731135AbhAOAFi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Jan 2021 19:05:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610669051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xQ0ErKvc7UzwqNKxM2CmsA5gF/0THDUFsSSbaFvNOvI=;
        b=Ye4X8EEmdzAvtX8m3mK34Au4aE2rJlaAvmAzhBWRR09N76NIlZxv8jkYPaCjU0L8X4Kv5V
        fu9zr6qaiT79zhvu9VLv9ma74CIIm6zS686+a7Hrez+MCbYbrsVx8cFs1jNkLxUc1MVdtb
        1/IHPhyfF2FWCpHLQxGTOtSEdjD1ybs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-jopQxvanNzadbIv647B3qA-1; Thu, 14 Jan 2021 19:04:10 -0500
X-MC-Unique: jopQxvanNzadbIv647B3qA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 425DE107ACF7;
        Fri, 15 Jan 2021 00:04:08 +0000 (UTC)
Received: from treble (ovpn-120-156.rdu2.redhat.com [10.10.120.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B534B19C45;
        Fri, 15 Jan 2021 00:04:01 +0000 (UTC)
Date:   Thu, 14 Jan 2021 18:03:59 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH] Documentation: livepatch: document reliable stacktrace
Message-ID: <20210115000359.dxzivd7hvqvhkqji@treble>
References: <20210113165743.3385-1-broonie@kernel.org>
 <20210113192735.rg2fxwlfrzueinci@treble>
 <20210113202315.GI4641@sirena.org.uk>
 <20210113222541.ysvtievx4o5r42ym@treble>
 <20210114181013.GE2739@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210114181013.GE2739@C02TD0UTHF1T.local>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 14, 2021 at 06:10:13PM +0000, Mark Rutland wrote:
> On Wed, Jan 13, 2021 at 04:25:41PM -0600, Josh Poimboeuf wrote:
> > On Wed, Jan 13, 2021 at 08:23:15PM +0000, Mark Brown wrote:
> > > On Wed, Jan 13, 2021 at 01:33:13PM -0600, Josh Poimboeuf wrote:
> > > 
> > > > I think it's worth mentioning a little more about objtool.  There are a
> > > > few passing mentions of objtool's generation of metadata (i.e. ORC), but
> > > > objtool has another relevant purpose: stack validation.  That's
> > > > particularly important when it comes to frame pointers.
> > > 
> > > > For some architectures like x86_64 and arm64 (but not powerpc/s390),
> > > > it's far too easy for a human to write asm and/or inline asm which
> > > > violates frame pointer protocol, silently causing the violater's callee
> > > > to get skipped in the unwind.  Such architectures need objtool
> > > > implemented for CONFIG_STACK_VALIDATION.
> > > 
> > > This basically boils down to just adding a statement saying "you may
> > > need to depend on objtool" I think?
> > 
> > Right, but maybe it would be a short paragraph or two.
> 
> I reckon that's a top-level section between requirements and
> consideration along the lines of:
> 
> 3. Compile-time analysis
> ========================
> 
> To ensure that kernel code can be correctly unwound in all cases,
> architectures may need to verify that code has been compiled in a manner
> expected by the unwinder. For example, an unwinder may expect that
> functions manipulate the stack pointer in a limited way, or that all
> functions use specific prologue and epilogue sequences. Architectures
> with such requirements should verify the kernel compilation using
> objtool.
> 
> In some cases, an unwinder may require metadata to correctly unwind.
> Where necessary, this metadata should be generated at build time using
> objtool.

Sounds good to me.

-- 
Josh

