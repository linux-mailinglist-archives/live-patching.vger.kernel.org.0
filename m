Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19AF340BFF
	for <lists+live-patching@lfdr.de>; Thu, 18 Mar 2021 18:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhCRRkm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 18 Mar 2021 13:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230431AbhCRRke (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 18 Mar 2021 13:40:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19B8764F1D;
        Thu, 18 Mar 2021 17:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616089233;
        bh=eTxd6Y3lO9P3INIl5OgeGP77pBRn4F5bfcQPCAvEYXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QNBKr486S9km8ea3BcnlXxO0zeB4LXS2cb7+CrWFx6UZrObRX/LygJkX4jbsmzvse
         kmCqQEAolb5msqnBM881ty/bE9ptZlb/yJ320RkMtVoHhi91OqK7bC4GXqPmTowoYP
         jIzmwPdfJougkQkPK/ltnPsh5R2I8HRPOD12HdUBcnPjQtebsdIaO6Cptoh0F5lYxw
         41SAOHYoGD0ZdOuTwBhMb5uPDKvEEEtK1L4llvLg0thgp5x/maGASlSW7m2uhw57fh
         Qa7SM/vGvVhQxGZSImtTozgHE9SZFXwpE1bWgDWFVVDJp0oT9VgLVXzgZNtRqFgLUE
         0oX64F35OqsUQ==
Date:   Thu, 18 Mar 2021 17:40:29 +0000
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/8] arm64: Implement frame types
Message-ID: <20210318174029.GM5469@sirena.org.uk>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZmZU9S7l/XJx5q9b"
Content-Disposition: inline
In-Reply-To: <20210315165800.5948-3-madvenka@linux.microsoft.com>
X-Cookie: You are false data.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--ZmZU9S7l/XJx5q9b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 15, 2021 at 11:57:54AM -0500, madvenka@linux.microsoft.com wrote:

> To summarize, pt_regs->stackframe is used (or will be used) as a marker
> frame in stack traces. To enable the unwinder to detect these frames, tag
> each pt_regs->stackframe with a type. To record the type, use the unused2
> field in struct pt_regs and rename it to frame_type. The types are:

Unless I'm misreading what's going on here this is more trying to set a
type for the stack as a whole than for a specific stack frame.  I'm also
finding this a bit confusing as the unwinder already tracks things it
calls frame types and it handles types that aren't covered here like
SDEI.  At the very least there's a naming issue here.

Taking a step back though do we want to be tracking this via pt_regs?
It's reliant on us robustly finding the correct pt_regs and on having
the things that make the stack unreliable explicitly go in and set the
appropriate type.  That seems like it will be error prone, I'd been
expecting to do something more like using sections to filter code for
unreliable features based on the addresses of the functions we find on
the stack or similar.  This could still go wrong of course but there's
fewer moving pieces, and especially fewer moving pieces specific to
reliable stack trace.

I'm wary of tracking data that only ever gets used for the reliable
stack trace path given that it's going to be fairly infrequently used
and hence tested, especially things that only crop up in cases that are
hard to provoke reliably.  If there's a way to detect things that
doesn't use special data that seems safer.

> EL1_FRAME
> 	EL1 exception frame.

We do trap into EL2 as well, the patch will track EL2 frames as EL1
frames.  Even if we can treat them the same the naming ought to be
clear.

> FTRACE_FRAME
>         FTRACE frame.

This is implemented later in the series.  If using this approach I'd
suggest pulling the change in entry-ftrace.S that sets this into this
patch, it's easier than adding a note about this being added later and
should help with any bisect issues.

--ZmZU9S7l/XJx5q9b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBTkI0ACgkQJNaLcl1U
h9AGYgf/eLULWueR+lYuF43H4JsKlcPty+nratz9/9604ftfM345NlBSpEdD+0AC
Pn2VplG5JfSvdyJaVWzB4LsuH+Eet+Rm2bMlpbmHRvkCAGKbl01PQws5q712pZ/v
r6I+pmlk5T1wmjOfQJSCPiSI+AecFQhXLrdOi4Fp2bvPtFqcm9WASYI07rsDLBhr
Bh2NlFC+MokW/K1d+HXjzmPudwQ92axCS1rXw365frfj4lLVKZ1S8vHAfyaOKDM8
Hth0VqK1hQcl+0KekkmVeEZ4KzbniqO2L/dTikEeecz25hCk7EawXf/a65tCF/UC
mO2CkbXcpX1M/PApLtc3oTimg3m3FQ==
=NryZ
-----END PGP SIGNATURE-----

--ZmZU9S7l/XJx5q9b--
