Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CADB719A02A
	for <lists+live-patching@lfdr.de>; Tue, 31 Mar 2020 22:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgCaUwT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 31 Mar 2020 16:52:19 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32469 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727852AbgCaUwT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 31 Mar 2020 16:52:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585687938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2nbVPbn2iR3iLDc6iH5vBuYrftFt4cVUylDpjgAgpPo=;
        b=Zm3/1qkJgg7O+VdF5vjd+olErWrjnvp844/wqDLPVjwKMwyGeFSl0MSsxYRCg/nhewlYop
        Mqs5Q+20OQ45R63GOsLgUzW2T0J17IquOxILntBN8MVcsT0Xgxm14/GhpZQnqlEajbo5EB
        PLQczqDcYsKewnn5O9FS3KTOGlQIz6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271--MfGrA8MO4i53vost88-8A-1; Tue, 31 Mar 2020 16:52:09 -0400
X-MC-Unique: -MfGrA8MO4i53vost88-8A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79CF7100551A;
        Tue, 31 Mar 2020 20:52:07 +0000 (UTC)
Received: from redhat.com (ovpn-114-27.phx2.redhat.com [10.3.114.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B1A8DA0E7;
        Tue, 31 Mar 2020 20:52:06 +0000 (UTC)
Date:   Tue, 31 Mar 2020 16:52:04 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Nicolai Stange <nstange@suse.com>,
        Jason Baron <jbaron@akamai.com>,
        Gabriel Gomes <gagomes@suse.com>,
        Alice Ferrazzi <alice.ferrazzi@gmail.com>,
        Michael Matz <matz@suse.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        ulp-devel@opensuse.org, live-patching@vger.kernel.org
Subject: Re: Live patching MC at LPC2020?
Message-ID: <20200331205204.GA7388@redhat.com>
References: <nycvar.YFH.7.76.2003271409380.19500@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.2003271409380.19500@cbobk.fhfr.pm>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Mar 27, 2020 at 02:20:52PM +0100, Jiri Kosina wrote:
> Hi everybody,
> 
> oh well, it sounds a bit awkward to be talking about any conference plans 
> for this year given how the corona things are untangling in the world, but 
> LPC planning committee has issued (a) statement about Covid-19 (b) call 
> for papers (as originally planned) nevertheless. Please see:
> 
> 	https://linuxplumbersconf.org/
> 	https://linuxplumbersconf.org/event/7/abstracts/
> 
> for details.
> 
> Under the asumption that this Covid nuisance is over by that time and 
> travel is possible (and safe) again -- do we want to eventually submit a 
> livepatching miniconf proposal again?
> 
> I believe there are still kernel related topics on our plate (like revised 
> handling of the modules that has been agreed on in Lisbon and Petr has 
> started to work on, the C parsing effort by Nicolai, etc), and at the same 
> time I'd really like to include the new kids on the block too -- the 
> userspace livepatching folks (CCing those I know for sure are working on 
> it).
> 

Hi Jiri,

First off, I hope everyone is riding out COVID-19 as well as possible,
considering all that's happening.

As for LPC mini-conf topics, I'd be interested in (at least):

- Petr's per-object livepatch POC
- klp-convert status
- objtool hacking
- Nicolai's klp-ccp status
- arch update (arm64, etc)

> So, please if you have any opinion one way or the other, please speak up. 
> Depending on the feedback, I will be fine handling the logistics of the 
> miniconf submission as last year (together with Josh I guess?) unless 
> someone else wants to step up and volunter himself :)
> 
> (*) which is totally unclear, yes -- for example goverment in my country 
>     has been talking for border closure lasting for 1+ years ... but it 
>     all depends on how things develop of course).

Hmm, all good points.  Some conferences have gone virtual to cope with
necessary cancellations, but who knows what things will look like even
at the end of August.  Perhaps we can still do something remotely if the
conditions dictate it.  But my vote would be yes, and let's see what
topics interest folks.

Regards,

-- Joe

