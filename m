Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5891E4708
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2020 17:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389478AbgE0PJg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 27 May 2020 11:09:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22336 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389316AbgE0PJg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 27 May 2020 11:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590592175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5Q+tiWXutRIqQpCDt/R8HQy8bIbn5DeYuPzOvb2NgNU=;
        b=hmWslb1qMb/f3JLo7XDfqeZCArqX5NUaIYhLRyWz1JuAkMXnDzKJV+D/G9lfME8V1CRZUh
        poRDbwuLuCHdmu65R8SrbRSal1uGWwmEswiOmCKy9hy29LNxjvyCHWnhz2woCJiL2r1+21
        2u93otZPBJA/nTTgLdweVE+dUfgQ9qg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-HNNlR5CqP0um4eixLPE_ag-1; Wed, 27 May 2020 11:09:31 -0400
X-MC-Unique: HNNlR5CqP0um4eixLPE_ag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CA831005512;
        Wed, 27 May 2020 15:09:29 +0000 (UTC)
Received: from treble (ovpn-112-77.rdu2.redhat.com [10.10.112.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B21DD98A3F;
        Wed, 27 May 2020 15:09:27 +0000 (UTC)
Date:   Wed, 27 May 2020 10:09:25 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Martin Jambor <mjambor@suse.cz>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, mliska@suse.cz,
        pmladek@suse.cz, live-patching@vger.kernel.org,
        Jan Hubicka <hubicka@ucw.cz>
Subject: Re: linux-next: Tree for May 21 (objtool warnings)
Message-ID: <20200527150925.jytr4lnqptxlhsbi@treble>
References: <20200522001209.07c19400@canb.auug.org.au>
 <22332d9b-5e9f-5474-adac-9b3e39861aee@infradead.org>
 <alpine.LSU.2.21.2005251101030.24984@pobox.suse.cz>
 <alpine.LSU.2.21.2005251303430.24984@pobox.suse.cz>
 <20200526140113.ppjywpx7uir3vrlj@treble>
 <alpine.LSU.2.21.2005261809480.22611@pobox.suse.cz>
 <ri65zch21ri.fsf@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ri65zch21ri.fsf@suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, May 27, 2020 at 10:57:53AM +0200, Martin Jambor wrote:
> Hi,
> 
> On Tue, May 26 2020, Miroslav Benes wrote:
> > On Tue, 26 May 2020, Josh Poimboeuf wrote:
> >
> >> On Mon, May 25, 2020 at 01:07:27PM +0200, Miroslav Benes wrote:
> >> > > I'll try to find out which optimization does this, because it is a 
> >> > > slightly different scenario than hiding __noreturn from the callees. 
> >> > > Probably -fno-ipa-pure-const again.
> >> > 
> >> > And it is indeed -fno-ipa-pure-const again.
> >> 
> >> It still seems odd to me that GCC's dead end detection seems to break
> >> with -fno-ipa-pure-const.  Do you know if these issues can be fixed on
> >> the GCC side?
> >
> > It is odd. I asked Martin and Martin about that yesterday (CCed). It could 
> > be possible to enable just noreturn propagation for -flive-patching if I 
> > understood correctly. The attribute would need to be preserved in a 
> > patched function then, but that should be manageable.
> >
> > Marking functions as __noreturn is one thing (I think it is useful on its 
> > own as mentioned in the older thread about -flive-patching), but 
> > __always_inline solution in this case is really arbitrary.
> 
> Noreturn functions generally tend to be very cold ones and so you do not
> really want to inline them.

The issue here is that with -fno-ipa-pure-const, GCC no longer
automatically detects that the static inline function is noreturn, so it
emits unreachable instructions after a call to it.

-- 
Josh

