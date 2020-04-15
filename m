Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC111A907F
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2020 03:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392637AbgDOBbf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Apr 2020 21:31:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55332 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2392634AbgDOBbd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Apr 2020 21:31:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586914292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1gQDebgdhfevaZB94Up55P4Eie+YbxHp+6IgQaQXMeo=;
        b=axbnrEX4wjiSgX3FpuY7uyySZQhZrWSFvefMNEMKePAswm2grep1p1gAAJaiSN0H5CX2L/
        tiqvRwPxT6MkC85GX+Rj0TlNkbaudpHEFNY9XZJBmHlxdUtK0BGzZv0VR79QC/25v5VQGT
        ZK3uVX1SOaCdivzoKioxB4S+bCnh/+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-6Z9TQ_sIPqS5vnz00oax3Q-1; Tue, 14 Apr 2020 21:31:25 -0400
X-MC-Unique: 6Z9TQ_sIPqS5vnz00oax3Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB363107ACC7;
        Wed, 15 Apr 2020 01:31:24 +0000 (UTC)
Received: from treble (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B3F7B9F9BB;
        Wed, 15 Apr 2020 01:31:20 +0000 (UTC)
Date:   Tue, 14 Apr 2020 20:31:17 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 0/7] livepatch,module: Remove .klp.arch and
 module_disable_ro()
Message-ID: <20200415013117.rc7vlidmo4okzypl@treble>
References: <cover.1586881704.git.jpoimboe@redhat.com>
 <187a2ccd-1d04-54db-2fd3-8c4ca6872830@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <187a2ccd-1d04-54db-2fd3-8c4ca6872830@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 14, 2020 at 08:57:15PM -0400, Joe Lawrence wrote:
> On 4/14/20 12:28 PM, Josh Poimboeuf wrote:
> > Better late than never, these patches add simplifications and
> > improvements for some issues Peter found six months ago, as part of his
> > non-writable text code (W^X) cleanups.
> > 
> > Highlights:
> > 
> > - Remove the livepatch arch-specific .klp.arch sections, which were used
> >    to do paravirt patching and alternatives patching for livepatch
> >    replacement code.
> > 
> > - Add support for jump labels in patched code.
> 
> Re: jump labels and late-module patching support...
> 
> Is there still an issue of a non-exported static key defined in a
> to-be-patched module referenced and resolved via klp-relocation when the
> livepatch module is loaded first?  (Basically the same case I asked Petr
> about in his split livepatch module PoC. [1])
> 
> Or should we declare this an invalid klp-relocation use case and force the
> livepatch author to use static_key_enabled()?
> 
> [1] https://lore.kernel.org/lkml/20200407205740.GA17061@redhat.com/

Right, if the static key lives in a module, then it's still not possible
for a jump label to use it.  I added a check in kpatch-build to block
that case and suggest static_key_enabled() instead.

I don't know what the solution is, other than getting rid of late module
patching.

I confess I haven't looked at Petr's patches due to other distractions,
but I plan to soon.

-- 
Josh

