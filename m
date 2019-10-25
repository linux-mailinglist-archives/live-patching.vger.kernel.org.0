Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CED8E4CAA
	for <lists+live-patching@lfdr.de>; Fri, 25 Oct 2019 15:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504936AbfJYNut (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 25 Oct 2019 09:50:49 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36315 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2502198AbfJYNut (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 25 Oct 2019 09:50:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572011443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oEj+bO/nqtxOP3DiJvOVmlfYassIXPvH8i+dtMXWRIg=;
        b=bPTtsZLDV0K7QUBJbY9ekWU+33en2dmk+cbh9RjB1VgJRHQmrgyM8J9tFCW2MwuaPMvsM3
        wHJeCxMrB/RTsrX/ts6YR9R7+H5+zNf5ZiOI9sQdNlaB1hD8aDm0obmmGiVr/ePf5kTEN3
        VcZgRBP1HDoKkI1MIHeP1FtetGDXLFk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-7HRoqzFtPhC_9Bvf_tjP0A-1; Fri, 25 Oct 2019 09:50:31 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C60847B;
        Fri, 25 Oct 2019 13:50:29 +0000 (UTC)
Received: from treble (ovpn-121-225.rdu2.redhat.com [10.10.121.225])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B167460852;
        Fri, 25 Oct 2019 13:50:24 +0000 (UTC)
Date:   Fri, 25 Oct 2019 08:50:22 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Petr Mladek <pmladek@suse.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jeyu@kernel.org,
        live-patching@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 15/16] module: Move where we mark modules RO,X
Message-ID: <20191025135022.civcnjkp563hvlsk@treble>
References: <20191018073525.768931536@infradead.org>
 <20191018074634.801435443@infradead.org>
 <20191021135312.jbbxsuipxldocdjk@treble>
 <20191021141402.GI1817@hirez.programming.kicks-ass.net>
 <20191023114835.GT1817@hirez.programming.kicks-ass.net>
 <20191023170025.f34g3vxaqr4f5gqh@treble>
 <20191024131634.GC4131@hirez.programming.kicks-ass.net>
 <20191025064456.6jjrngm4m3mspaxw@pathway.suse.cz>
 <20191025084300.GG4131@hirez.programming.kicks-ass.net>
 <20191025100612.GB5671@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
In-Reply-To: <20191025100612.GB5671@hirez.programming.kicks-ass.net>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 7HRoqzFtPhC_9Bvf_tjP0A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Oct 25, 2019 at 12:06:12PM +0200, Peter Zijlstra wrote:
> On Fri, Oct 25, 2019 at 10:43:00AM +0200, Peter Zijlstra wrote:
>=20
> > But none of that explains why apply_alternatives() is also delayed.
> >=20
> > So I'm very tempted to just revert that patchset for doing it all
> > wrong.
>=20
> And I've done just that. This includes Josh's validation patch, the
> revert and my klp_appy_relocations_add() patches with the removal of
> module_disable_ro().
>=20
> Josh, can you test or give me clue on how to test? I need to run a few
> errands today, but I'll try and have a poke either tonight or tomorrow.
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git x86/rwx

Thanks.  I'll work on hacking up kpatch-build to support this, and then
I'll need to run it through a lot of testing to make sure this was a
good idea.

--=20
Josh

