Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B30F229DB0
	for <lists+live-patching@lfdr.de>; Wed, 22 Jul 2020 19:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbgGVRDJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Jul 2020 13:03:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40554 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726666AbgGVRDJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Jul 2020 13:03:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595437387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rNxAC2081w6KkDSHTZofG7jYDLRJsJOKNUQR0/igp1I=;
        b=ALIKBDfsvDxoH5zu0hVo39m/t08eIebmpgAxHLw7Uns570kyWUw9yIxgXJNRRVaVEKZ1g5
        kvqktIjETNJAiQSgAY4X/V0F59Jyk6y71+NKFAjCoc+ZvrmCKn/LQMWFeUruOnPyGDa903
        fVGCKTVirGgoYrJJ7I9g28sDVYkGFaw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-UlCdbfnNNT6NNRdnZGjhwA-1; Wed, 22 Jul 2020 13:03:05 -0400
X-MC-Unique: UlCdbfnNNT6NNRdnZGjhwA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C422181EDEE;
        Wed, 22 Jul 2020 17:03:04 +0000 (UTC)
Received: from [10.10.114.255] (ovpn-114-255.rdu2.redhat.com [10.10.114.255])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 611221017E28;
        Wed, 22 Jul 2020 17:03:04 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH 1/2] docs/livepatch: Add new compiler considerations doc
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200721161407.26806-1-joe.lawrence@redhat.com>
 <20200721161407.26806-2-joe.lawrence@redhat.com>
 <20200721230442.5v6ah7bpjx4puqva@treble>
Message-ID: <de3672ef-8779-245f-943d-3d5a4b875446@redhat.com>
Date:   Wed, 22 Jul 2020 13:03:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200721230442.5v6ah7bpjx4puqva@treble>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 7/21/20 7:04 PM, Josh Poimboeuf wrote:
> On Tue, Jul 21, 2020 at 12:14:06PM -0400, Joe Lawrence wrote:
>> Compiler optimizations can have serious implications on livepatching.
>> Create a document that outlines common optimization patterns and safe
>> ways to livepatch them.
>>
>> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> 
> There's a lot of good info here, but I wonder if it should be
> reorganized a bit and instead called "how to create a livepatch module",
> because that's really the point of it all.
> 

That would be nice.  Would you consider a stand-alone 
compiler-optimizations doc an incremental step towards that end?  Note 
that the other files (callbacks, shadow-vars, system-state) in their 
current form might be as confusing to the newbie.

> I'm thinking a newcomer reading this might be lost.  It's not
> necessarily clear that there are currently two completely different
> approaches to creating a livepatch module, each with their own quirks
> and benefits/drawbacks.  There is one mention of a "source-based
> livepatch author" but no explanation of what that means.
> 

Yes, the initial draft was light on source-based patching since I only 
really tinker with it for samples/kselftests.  The doc was the result of 
an experienced livepatch developer and Sunday afternoon w/the compiler. 
I'm sure it reads as such. :)

> Maybe it could begin with an overview of the two approaches, and then
> delve more into the details of each approach, and then delve even more
> into the gory details about compiler optimizations.
> 

Up until now, the livepatch documentation has danced around the 
particular creation method and only described the API in abstract.  If a 
compiler considerations doc needs to have that complete context then I'd 
suggest we reorganize the entire lot as a prerequisite.

> Also the kpatch-build section can reference the patch author guide which
> we have on github.
> 

Good point.  I think there are a few kpatch-specific implications 
(sibling call changes maybe) to consider.

-- Joe

