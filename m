Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF50B20FF65
	for <lists+live-patching@lfdr.de>; Tue, 30 Jun 2020 23:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgF3VqD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Jun 2020 17:46:03 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43945 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728205AbgF3VqC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Jun 2020 17:46:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593553561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xSGR+2AtpMMqNY4d55iQ5FyoVPs+lh6SFJWS4mBlL0M=;
        b=a90X2le2Kuo+pvKyerpFLwLaLcfdHJEL7XMlawqi6RymZCvvlMx5OGQCRX5/khFfwdMhOx
        ICGr6Jin65I/w0v1UfI/I5L2kGSE+yMEaMsnAIj/L+X6hQLbdfC2DEhiySfCn4seFe31Xl
        L38gxdvNKH1GbkKvsvX/MuMD4ZHUB5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-8qDLoif2ODONDHNVw9g3Hg-1; Tue, 30 Jun 2020 17:45:59 -0400
X-MC-Unique: 8qDLoif2ODONDHNVw9g3Hg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E243800C60;
        Tue, 30 Jun 2020 21:45:57 +0000 (UTC)
Received: from treble (ovpn-114-241.rdu2.redhat.com [10.10.114.241])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C69C619C4F;
        Tue, 30 Jun 2020 21:45:52 +0000 (UTC)
Date:   Tue, 30 Jun 2020 16:45:50 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Nicolai Stange <nstange@suse.com>,
        Jason Baron <jbaron@akamai.com>,
        Gabriel Gomes <gagomes@suse.com>,
        Alice Ferrazzi <alice.ferrazzi@gmail.com>,
        Michael Matz <matz@suse.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        ulp-devel@opensuse.org, live-patching@vger.kernel.org
Subject: Re: Live patching MC at LPC2020?
Message-ID: <20200630214550.cbli6oex4xskwdjp@treble>
References: <nycvar.YFH.7.76.2003271409380.19500@cbobk.fhfr.pm>
 <20200331205204.GA7388@redhat.com>
 <20200625065943.GB6156@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200625065943.GB6156@alley>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jun 25, 2020 at 08:59:43AM +0200, Petr Mladek wrote:
> On Tue 2020-03-31 16:52:04, Joe Lawrence wrote:
> It seems that there is interest into sharing/discussing some topics.
> The question is whether is has to be under the LPC even umbrella.
> 
> Advantages of LPC:
> 
>    + well defined date
>    + more attendees (ARM people, Steven Rostedt ;-)
>    + access to some powerful video conference tool
>    + access to another LPC content
>    + support for the conference in the long term
> 
> 
> Advantages of self-organized event:
> 
>    + less paperwork?
>    + cheaper?
>    + only interested people invited
>    + date after summer holidays
>    + more time for the discussion
> 
> I am in the favor of self organized event. For me, LPC is much less
> interesting without the personal contact and hallway conversations.
> All the LPC date is not ideal for me.

I'd prefer LPC proper, as it would be easier (infrastructure is already
taken care of) and more inclusive (in the past we often got good
feedback from outside the direct livepatch community).  And it's only
$50 US.

But to be honest I have doubts about the usefulness of any online
conference, so either way may be equally useless ;-)

-- 
Josh

