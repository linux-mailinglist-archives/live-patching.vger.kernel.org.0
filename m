Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214CFF22E8
	for <lists+live-patching@lfdr.de>; Thu,  7 Nov 2019 00:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfKFXyc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Nov 2019 18:54:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30988 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727369AbfKFXyc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Nov 2019 18:54:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573084471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OeBSvkxKgLwEN5Lh3YlOG/EG6vi47zYej441MNR7eJM=;
        b=UQC0m0r9p+IIhdsv5Ur3HJtVs1YTBiFx8WAyvDgUSthwLf1bNl35o7lrj1Iq4huo9ggixn
        07+oWnxpX9uvazg6VDzdpAc9bmZ9G2zUeAmy47rUddV4aCPsDZnVMfHSzOukSb9SMnRU2r
        a0eDwxeQtL/b8p+Jo7m+1TdgGG8EPnM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-R_j9mkZuOLSRp0VQugwtwA-1; Wed, 06 Nov 2019 18:54:29 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F00FF1800D63;
        Wed,  6 Nov 2019 23:54:28 +0000 (UTC)
Received: from treble (ovpn-122-162.rdu2.redhat.com [10.10.122.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 71EE31A7E3;
        Wed,  6 Nov 2019 23:54:25 +0000 (UTC)
Date:   Wed, 6 Nov 2019 17:54:23 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH] x86/stacktrace: update kconfig help text for reliable
 unwinders
Message-ID: <20191106235423.hjamrggd4x3js5hm@treble>
References: <20191106224344.8373-1-joe.lawrence@redhat.com>
 <20191106230553.wnyltmkzwk5dph4l@treble>
 <c8bae684-2a46-68e6-dc43-a8c215bdd111@redhat.com>
MIME-Version: 1.0
In-Reply-To: <c8bae684-2a46-68e6-dc43-a8c215bdd111@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: R_j9mkZuOLSRp0VQugwtwA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Nov 06, 2019 at 06:16:28PM -0500, Joe Lawrence wrote:
> On 11/6/19 6:05 PM, Josh Poimboeuf wrote:
> > On Wed, Nov 06, 2019 at 05:43:44PM -0500, Joe Lawrence wrote:
> > > commit 6415b38bae26 ("x86/stacktrace: Enable HAVE_RELIABLE_STACKTRACE
> > > for the ORC unwinder") marked the ORC unwinder as a "reliable" unwind=
er.
> > > Update the help text to reflect that change: the frame pointer unwind=
er
> > > is no longer the only one that provides HAVE_RELIABLE_STACKTRACE.
> > >=20
> > > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > > ---
> > >   arch/x86/Kconfig.debug | 8 ++++----
> > >   1 file changed, 4 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> > > index bf9cd83de777..69cdf0558c13 100644
> > > --- a/arch/x86/Kconfig.debug
> > > +++ b/arch/x86/Kconfig.debug
> > > @@ -316,10 +316,6 @@ config UNWINDER_FRAME_POINTER
> > >   =09  unwinder, but the kernel text size will grow by ~3% and the ke=
rnel's
> > >   =09  overall performance will degrade by roughly 5-10%.
> > > -=09  This option is recommended if you want to use the livepatch
> > > -=09  consistency model, as this is currently the only way to get a
> > > -=09  reliable stack trace (CONFIG_HAVE_RELIABLE_STACKTRACE).
> > > -
> > >   config UNWINDER_GUESS
> > >   =09bool "Guess unwinder"
> > >   =09depends on EXPERT
> > > @@ -333,6 +329,10 @@ config UNWINDER_GUESS
> > >   =09  useful in many cases.  Unlike the other unwinders, it has no r=
untime
> > >   =09  overhead.
> > > +=09  This option is not recommended if you want to use the livepatch
> > > +=09  consistency model, as this unwinder cannot guarantee reliable s=
tack
> > > +=09  traces.
> > > +
> >=20
> > I'm not sure whether this last hunk is helpful.  At the very least the
> > wording of "not recommended" might be confusing because it's not even
> > possible to combine UNWINDER_GUESS+HAVE_RELIABLE_STACKTRACE.
> >=20
> > arch/x86/Kconfig:       select HAVE_RELIABLE_STACKTRACE         if X86_=
64 && (UNWINDER_FRAME_POINTER || UNWINDER_ORC) && STACK_VALIDATION
> >=20
>=20
> Ah good point.  The alternative would be to copy the recommended note to
> both UNWINDER_FRAME_POINTER and UNWINDER_ORC, or at least remove the "onl=
y"
> phrasing.  I dunno, nobody has noticed it yet, so maybe the first hunk wo=
uld
> be good enough.

The guess unwinder is listed as an expert option, so the user would have
to enable CONFIG_EXPERT to get to it.  Then if they do enable it and try
to load a livepatch, they'll get a runtime warning along with a patch
which never transitions.

And like you said, nobody has complained, so I'd say just dropping the
2nd hunk would be fine.

--=20
Josh

