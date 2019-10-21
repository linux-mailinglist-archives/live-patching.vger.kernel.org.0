Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F1BDF0D4
	for <lists+live-patching@lfdr.de>; Mon, 21 Oct 2019 17:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfJUPGM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Oct 2019 11:06:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36040 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727406AbfJUPGM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Oct 2019 11:06:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571670371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w1Uk+G0ifBUIpwhzR5PkBxVjQYIPz5NNh0QhaPcxzII=;
        b=IdPQG6r2npv4EGVrBMn4SFnVS3G8jtC0nwRjEvkcWETW+bhB5J+nVvxLOEGjnHiBPJ7eVE
        VhuU/m2hkGdFK2J+lAu/dwm9lL2Hqex/lZt/LaT6buxZHEJV9f0hWE2lX7sYfwJFGgkIKv
        UanZD7ZhcDZuvNl7r0NsLOTErMJv7Fw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-A_Ae64ZONgmJRM78UBiNUg-1; Mon, 21 Oct 2019 11:06:07 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 381E81005500;
        Mon, 21 Oct 2019 15:06:05 +0000 (UTC)
Received: from treble (ovpn-123-96.rdu2.redhat.com [10.10.123.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FCD0608C0;
        Mon, 21 Oct 2019 15:05:51 +0000 (UTC)
Date:   Mon, 21 Oct 2019 10:05:49 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        x86@kernel.org, linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
Message-ID: <20191021150549.bitgqifqk2tbd3aj@treble>
References: <20191010172819.GS2328@hirez.programming.kicks-ass.net>
 <20191011125903.GN2359@hirez.programming.kicks-ass.net>
 <20191015130739.GA23565@linux-8ccs>
 <20191015135634.GK2328@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz>
 <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
 <20191015153120.GA21580@linux-8ccs>
 <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
 <20191015182705.1aeec284@gandalf.local.home>
 <20191016074217.GL2328@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
In-Reply-To: <20191016074217.GL2328@hirez.programming.kicks-ass.net>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: A_Ae64ZONgmJRM78UBiNUg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 16, 2019 at 09:42:17AM +0200, Peter Zijlstra wrote:
> > which are not compatible with livepatching. GCC upstream now has
> > -flive-patching option, which disables all those interfering optimizati=
ons.
>=20
> Which, IIRC, has a significant performance impact and should thus really
> not be used...
>=20
> If distros ship that crap, I'm going to laugh at them the next time they
> want a single digit performance improvement because *important*.

I have a crazy plan to try to use objtool to detect function changes at
a binary level, which would hopefully allow us to drop this flag.

But regardless, I wonder if we enabled this flag prematurely.  We still
don't have a reasonable way to use it for creating source-based live
patches upstream, and it should really be optional for CONFIG_LIVEPATCH,
since kpatch-build doesn't need it.

--=20
Josh

