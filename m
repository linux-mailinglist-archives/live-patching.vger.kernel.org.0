Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB8922A0EF
	for <lists+live-patching@lfdr.de>; Wed, 22 Jul 2020 22:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732921AbgGVUvt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Jul 2020 16:51:49 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57274 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726447AbgGVUvt (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Jul 2020 16:51:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595451107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gREK6qCLK9pb41d3z9gQfGNfBTwDTOZTLCxEbymSjNM=;
        b=iebOv9384Yn+sjvJ0EZrhe1VNmhZU6fzaK1gqSoR91WO5/0AX0r9QpIKhOm+6sAA4Gx/T8
        qP298sDUwtMjiCV19dyacjUFCl1bW1CgfcB9jE5rJrFzGySXxqMPz1yeM0219RoD+Cb8MA
        /SoEVIvW5iCBgfrwOONW2ktT+awrFBA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-Oa6C2FLtPZe93I8etDCh2Q-1; Wed, 22 Jul 2020 16:51:45 -0400
X-MC-Unique: Oa6C2FLtPZe93I8etDCh2Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C29CC1030C2A;
        Wed, 22 Jul 2020 20:51:44 +0000 (UTC)
Received: from treble (ovpn-116-168.rdu2.redhat.com [10.10.116.168])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 46FBC8BECC;
        Wed, 22 Jul 2020 20:51:41 +0000 (UTC)
Date:   Wed, 22 Jul 2020 15:51:39 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] docs/livepatch: Add new compiler considerations doc
Message-ID: <20200722205139.hwbej2atk2ejq27n@treble>
References: <20200721161407.26806-1-joe.lawrence@redhat.com>
 <20200721161407.26806-2-joe.lawrence@redhat.com>
 <20200721230442.5v6ah7bpjx4puqva@treble>
 <de3672ef-8779-245f-943d-3d5a4b875446@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <de3672ef-8779-245f-943d-3d5a4b875446@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 22, 2020 at 01:03:03PM -0400, Joe Lawrence wrote:
> On 7/21/20 7:04 PM, Josh Poimboeuf wrote:
> > On Tue, Jul 21, 2020 at 12:14:06PM -0400, Joe Lawrence wrote:
> > > Compiler optimizations can have serious implications on livepatching.
> > > Create a document that outlines common optimization patterns and safe
> > > ways to livepatch them.
> > > 
> > > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > 
> > There's a lot of good info here, but I wonder if it should be
> > reorganized a bit and instead called "how to create a livepatch module",
> > because that's really the point of it all.
> > 
> 
> That would be nice.  Would you consider a stand-alone compiler-optimizations
> doc an incremental step towards that end?  Note that the other files
> (callbacks, shadow-vars, system-state) in their current form might be as
> confusing to the newbie.

It's an incremental step towards _something_.  Whether that's a cohesive
patch creation guide, or just a growing hodgepodge of random documents,
it may be too early to say :-)

> > I'm thinking a newcomer reading this might be lost.  It's not
> > necessarily clear that there are currently two completely different
> > approaches to creating a livepatch module, each with their own quirks
> > and benefits/drawbacks.  There is one mention of a "source-based
> > livepatch author" but no explanation of what that means.
> > 
> 
> Yes, the initial draft was light on source-based patching since I only
> really tinker with it for samples/kselftests.  The doc was the result of an
> experienced livepatch developer and Sunday afternoon w/the compiler. I'm
> sure it reads as such. :)

Are experienced livepatch developers the intended audience?  If so I
question what value this document has in its current form.  Presumably
experienced livepatch developers would already know this stuff.

> > Maybe it could begin with an overview of the two approaches, and then
> > delve more into the details of each approach, and then delve even more
> > into the gory details about compiler optimizations.
> > 
> 
> Up until now, the livepatch documentation has danced around the particular
> creation method and only described the API in abstract.  If a compiler
> considerations doc needs to have that complete context then I'd suggest we
> reorganize the entire lot as a prerequisite.

I wouldn't say it *needs* to have that context.  But it would be a lot
more useful with it.  As you pointed out, the existing documents do need
to be reorganized into a more cohesive whole.

-- 
Josh

