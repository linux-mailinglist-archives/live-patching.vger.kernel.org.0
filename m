Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B411A8862
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2020 20:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503306AbgDNSDO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Apr 2020 14:03:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23777 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503176AbgDNSBV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Apr 2020 14:01:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586887280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z05Q+2Rh6hZ2Arh2dMLAzEQOInQCTBfGLKRs8w+a0Pk=;
        b=cXTGo/8XY2ijXepE8k1eOgM/LZ2pI79khsm025PrMsyZObh+NzG83h5f7/ztE9uU8JpfTg
        4X96jPbID8MoDFtYlW0ZKU6f4fyO2aNn54UQ3RtTy1S9jc0KxfXAAkvSB0fTi2fhVH6An+
        3myUZE3h5iCU6HNB6wzhIOhJQiBVP0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-3uTR-LcoO8a8gbEDYIqANw-1; Tue, 14 Apr 2020 14:01:13 -0400
X-MC-Unique: 3uTR-LcoO8a8gbEDYIqANw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C666986A07C;
        Tue, 14 Apr 2020 18:01:11 +0000 (UTC)
Received: from treble (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2994360BE0;
        Tue, 14 Apr 2020 18:01:11 +0000 (UTC)
Date:   Tue, 14 Apr 2020 13:01:09 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 1/7] livepatch: Apply vmlinux-specific KLP relocations
 early
Message-ID: <20200414180109.da4v2b4ifpixuzn3@treble>
References: <cover.1586881704.git.jpoimboe@redhat.com>
 <8c3af42719fe0add37605ede634c7035a90f9acc.1586881704.git.jpoimboe@redhat.com>
 <20200414174406.GC2483@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200414174406.GC2483@worktop.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 14, 2020 at 07:44:06PM +0200, Peter Zijlstra wrote:
> On Tue, Apr 14, 2020 at 11:28:37AM -0500, Josh Poimboeuf wrote:
> > KLP relocations are livepatch-specific relocations which are applied to
> >   1) vmlinux-specific KLP relocation sections
> > 
> >      .klp.rela.vmlinux.{sec}
> > 
> >      These are relocations (applied to the KLP module) which reference
> >      unexported vmlinux symbols.
> > 
> >   2) module-specific KLP relocation sections
> > 
> >      .klp.rela.{module}.{sec}:
> > 
> >      These are relocations (applied to the KLP module) which reference
> >      unexported or exported module symbols.
> 
> Is there something that disallows a module from being called 'vmlinux' ?
> If not, we might want to enforce this somewhere.

I'm pretty sure we don't have a check for that anywhere, though the KLP
module would almost certainly fail during the module load when it
couldn't find the vmlinux.ko symbols it needed.

It wouldn't hurt to add a check somewhere though.  Maybe in
klp_module_coming() since the restriction only applies to
CONFIG_LIVEPATCH...

-- 
Josh

