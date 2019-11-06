Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6088EF2247
	for <lists+live-patching@lfdr.de>; Thu,  7 Nov 2019 00:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfKFXGE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Nov 2019 18:06:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30744 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727813AbfKFXGE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Nov 2019 18:06:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573081563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oz3HskjRqxhlPDCGk63+nwo4iuGFQJFiMO6YAWOvkkM=;
        b=GgDXazro+alhncTZ04jcmsXbIP8uYcyCIuP5+1e0kwKHUg8X/ayFPMAF/EEoFtDqy2qqAH
        FklH2APBHGq16e98yor7Pbfzn8WC9cPKWELY9lwsv+4C8MAyfgJTGzPMqy2h71VoiRzs6V
        D3IAAYuhcSSBpx4R5jDKbPX76Yq09hw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-EYyaIi7oOz6ejyNGGCbU1Q-1; Wed, 06 Nov 2019 18:06:02 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52FB4800C73;
        Wed,  6 Nov 2019 23:06:01 +0000 (UTC)
Received: from treble (ovpn-122-162.rdu2.redhat.com [10.10.122.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3ACB60BE0;
        Wed,  6 Nov 2019 23:05:57 +0000 (UTC)
Date:   Wed, 6 Nov 2019 17:05:53 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH] x86/stacktrace: update kconfig help text for reliable
 unwinders
Message-ID: <20191106230553.wnyltmkzwk5dph4l@treble>
References: <20191106224344.8373-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191106224344.8373-1-joe.lawrence@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: EYyaIi7oOz6ejyNGGCbU1Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Nov 06, 2019 at 05:43:44PM -0500, Joe Lawrence wrote:
> commit 6415b38bae26 ("x86/stacktrace: Enable HAVE_RELIABLE_STACKTRACE
> for the ORC unwinder") marked the ORC unwinder as a "reliable" unwinder.
> Update the help text to reflect that change: the frame pointer unwinder
> is no longer the only one that provides HAVE_RELIABLE_STACKTRACE.
>=20
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>  arch/x86/Kconfig.debug | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index bf9cd83de777..69cdf0558c13 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -316,10 +316,6 @@ config UNWINDER_FRAME_POINTER
>  =09  unwinder, but the kernel text size will grow by ~3% and the kernel'=
s
>  =09  overall performance will degrade by roughly 5-10%.
> =20
> -=09  This option is recommended if you want to use the livepatch
> -=09  consistency model, as this is currently the only way to get a
> -=09  reliable stack trace (CONFIG_HAVE_RELIABLE_STACKTRACE).
> -
>  config UNWINDER_GUESS
>  =09bool "Guess unwinder"
>  =09depends on EXPERT
> @@ -333,6 +329,10 @@ config UNWINDER_GUESS
>  =09  useful in many cases.  Unlike the other unwinders, it has no runtim=
e
>  =09  overhead.
> =20
> +=09  This option is not recommended if you want to use the livepatch
> +=09  consistency model, as this unwinder cannot guarantee reliable stack
> +=09  traces.
> +

I'm not sure whether this last hunk is helpful.  At the very least the
wording of "not recommended" might be confusing because it's not even
possible to combine UNWINDER_GUESS+HAVE_RELIABLE_STACKTRACE.

arch/x86/Kconfig:       select HAVE_RELIABLE_STACKTRACE         if X86_64 &=
& (UNWINDER_FRAME_POINTER || UNWINDER_ORC) && STACK_VALIDATION

--=20
Josh

