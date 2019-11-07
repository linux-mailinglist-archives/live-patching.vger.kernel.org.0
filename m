Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8998FF2607
	for <lists+live-patching@lfdr.de>; Thu,  7 Nov 2019 04:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfKGDfJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Nov 2019 22:35:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47699 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727279AbfKGDfJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Nov 2019 22:35:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573097708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RbBFAzU8gFLv11oHZoaqiXnPsseQp8Xs/d5KZuHznQM=;
        b=H5DXv+5cxR7SZt23U6gcHBeTa3HcrosYYCsoqAS3UdbZJVG5T0XddefH8tVMlRB6bTa8Zc
        nCUNmp0mvsWFi1YL02o7Jnsxsm961BnJF7FbFQ9KSjnK0A2coN0de5DWoi8r7PqsLp/aO9
        h/2tLUx9eiTBUTH0n/KBKMogtInJ8Rk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-5ltiCimYNaSqKDlbgHnOhQ-1; Wed, 06 Nov 2019 22:35:06 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E76F800C61;
        Thu,  7 Nov 2019 03:35:05 +0000 (UTC)
Received: from treble (ovpn-122-162.rdu2.redhat.com [10.10.122.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B450C600CE;
        Thu,  7 Nov 2019 03:34:59 +0000 (UTC)
Date:   Wed, 6 Nov 2019 21:34:58 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v2] x86/stacktrace: update kconfig help text for reliable
 unwinders
Message-ID: <20191107033458.ptvw6omypqndjt6d@treble>
References: <20191107032958.14034-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191107032958.14034-1-joe.lawrence@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 5ltiCimYNaSqKDlbgHnOhQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Nov 06, 2019 at 10:29:58PM -0500, Joe Lawrence wrote:
> commit 6415b38bae26 ("x86/stacktrace: Enable HAVE_RELIABLE_STACKTRACE
> for the ORC unwinder") added the ORC unwinder as a "reliable" unwinder.
> Update the help text to reflect that change: the frame pointer unwinder
> is no longer the only one that can provide HAVE_RELIABLE_STACKTRACE.
>=20
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>=20
> v2: dropped hunk that added unnecessary text to UNWIND_GUESS
>=20
>  arch/x86/Kconfig.debug | 4 ----
>  1 file changed, 4 deletions(-)
>=20
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index bf9cd83de777..409c00f74e60 100644
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
> --=20
> 2.21.0
>=20

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

--=20
Josh

