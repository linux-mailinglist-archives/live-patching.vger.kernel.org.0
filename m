Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F407B24111E
	for <lists+live-patching@lfdr.de>; Mon, 10 Aug 2020 21:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgHJTq4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 10 Aug 2020 15:46:56 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38831 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728241AbgHJTqz (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 10 Aug 2020 15:46:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597088811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oRzQMCTvJ3d/F0CLCTpkBaK+ztkIxK4SeNJuOlZ33WI=;
        b=DzGAPm4HU5lRBEVQOcvhGEipI/vDZGd+Y4AmckT1YuO7AiN1retYKTTMELFHqmAxfE6uel
        z5ZvbCPw+00z+I2W5gmKsidc1w7kDM+WNW7oG0NR/jZ5BCUgRufgv7HkSVFz5wD+zrxmtW
        l3xsPbhiqKr3UqVF5trensiRrv3brCQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-bTE2M3asMpSHOHqjSXL1hQ-1; Mon, 10 Aug 2020 15:46:49 -0400
X-MC-Unique: bTE2M3asMpSHOHqjSXL1hQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8B591005510;
        Mon, 10 Aug 2020 19:46:48 +0000 (UTC)
Received: from [10.10.120.16] (ovpn-120-16.rdu2.redhat.com [10.10.120.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D09BF19C4F;
        Mon, 10 Aug 2020 19:46:47 +0000 (UTC)
Subject: refactoring livepatch documentation was Re: [PATCH 1/2]
 docs/livepatch: Add new compiler considerations doc
To:     Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200721161407.26806-1-joe.lawrence@redhat.com>
 <20200721161407.26806-2-joe.lawrence@redhat.com>
 <20200721230442.5v6ah7bpjx4puqva@treble>
 <de3672ef-8779-245f-943d-3d5a4b875446@redhat.com>
 <20200722205139.hwbej2atk2ejq27n@treble> <20200806120336.GP24529@alley>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <3842fe65-332e-9f90-fe75-7cd80b34b75e@redhat.com>
Date:   Mon, 10 Aug 2020 15:46:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200806120336.GP24529@alley>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 8/6/20 8:03 AM, Petr Mladek wrote:
> On Wed 2020-07-22 15:51:39, Josh Poimboeuf wrote:
>> On Wed, Jul 22, 2020 at 01:03:03PM -0400, Joe Lawrence wrote:
>>> On 7/21/20 7:04 PM, Josh Poimboeuf wrote:
>>>> On Tue, Jul 21, 2020 at 12:14:06PM -0400, Joe Lawrence wrote:
>>>>> Compiler optimizations can have serious implications on livepatching.
>>>>> Create a document that outlines common optimization patterns and safe
>>>>> ways to livepatch them.
>>>>>
>>>>> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
>>>>
>>>> There's a lot of good info here, but I wonder if it should be
>>>> reorganized a bit and instead called "how to create a livepatch module",
>>>> because that's really the point of it all.
>>>>
>>>
>>> That would be nice.  Would you consider a stand-alone compiler-optimizations
>>> doc an incremental step towards that end?  Note that the other files
>>> (callbacks, shadow-vars, system-state) in their current form might be as
>>> confusing to the newbie.
>>
>> It's an incremental step towards _something_.  Whether that's a cohesive
>> patch creation guide, or just a growing hodgepodge of random documents,
>> it may be too early to say :-)
> 
> Yes, it would be nice to have a cohesive documentation. But scattered
> pieces are better than nothing.
> 
>>>> I'm thinking a newcomer reading this might be lost.  It's not
>>>> necessarily clear that there are currently two completely different
>>>> approaches to creating a livepatch module, each with their own quirks
>>>> and benefits/drawbacks.  There is one mention of a "source-based
>>>> livepatch author" but no explanation of what that means.
>>>>
>>>
>>> Yes, the initial draft was light on source-based patching since I only
>>> really tinker with it for samples/kselftests.  The doc was the result of an
>>> experienced livepatch developer and Sunday afternoon w/the compiler. I'm
>>> sure it reads as such. :)
>>
>> Are experienced livepatch developers the intended audience?  If so I
>> question what value this document has in its current form.  Presumably
>> experienced livepatch developers would already know this stuff.
> 
> IMHO, this document is useful even for newbies. They might at
> least get a clue about these catches. It is better than nothing.
> 
> I do not want to discourage Joe from creating even better
> documentation. But if he does not have interest or time
> to work on it, I am happy even for this piece.
> 

Hi Petr, Josh,

The compiler optimization pitfall document can wait for refactored 
livepatch documentation if that puts it into better context, 
particularly for newbies.  I don't mind either way.  FWIW, I don't 
profess to be an authoritative source its content -- we've dealt some of 
these issues in kpatch, so it was interesting to see how they affect 
livepatches that don't rely on binary comparison.


Toward the larger goal, I've changed the thread subject to talk about 
how we may rearrange and supplement our current documentation.  This is 
a first pass at a possible refactoring...


1. Provide a better index page to connect the other files/docs, like
https://www.kernel.org/doc/html/latest/core-api/index.html but obviously 
not that extensive.  Right now we have only a Table of Contents tree 
without any commentary.

2. Rearrange and refactor sections:

livepatch.rst
   Keep just about everything
   Add a history section to explain ksplice, kgraft, kpatch for the
     uninitiated?
   Add a section on source based vs. binary diff livepatch creation,
     this may be worth its own top-level section

Livepatch API
   Basic API
   Callbacks
   Shadow variables
   Cumulative patches
   System state

KLP Relocations
   Right now this is a bit academic AFAIK kpatch is the only tool
   currently making use of them.  So maybe this document becomes a
   more general purpose doc explaining how to reference unexported
   symbols?  (ie, how does kgraft currently do it, particularly
   w/kallsyms going unexported?)

   Eventually this could contain klp-convert howto if it ever gets
   merged.

Compiler considerations
   TBD

I suppose this doesn't create a "Livepatching creation for dummies" 
guide, but my feeling is that there are so many potential (hidden) 
pitfalls that such guide would be dangerous.

If someone were to ask me today how to start building a livepatch, I 
would probably point them at the samples to demonstrate the basic 
concept and API, but then implore them to read through the documentation 
to understand how quickly complicated it can become.

-- Joe

