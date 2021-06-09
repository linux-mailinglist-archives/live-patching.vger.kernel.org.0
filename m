Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990723A082A
	for <lists+live-patching@lfdr.de>; Wed,  9 Jun 2021 02:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhFIAOY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 8 Jun 2021 20:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhFIAOX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 8 Jun 2021 20:14:23 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CC3C061574;
        Tue,  8 Jun 2021 17:12:17 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id u18so16990532pfk.11;
        Tue, 08 Jun 2021 17:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dxe7pEHiiWXiBJZSIwOMrygbOqH/WOJMCAY2y1dqju4=;
        b=bCVG+XCMedF8CIK37bcU4hMLU1VFmsxJ3m8INfsqZd5rKyGShQdbQHUSr3mvIgqBHx
         1xwZ0/zn5wxr/FECsU8FlI50ef6rjQN/9rBfIALqPWzcnPDRknC8otp5Y1pZG+Jw4chP
         HoTV2MnQ6Oy8yaDc+SROBf9S9w042jdnz0QXAZJkgLGFvsucspt1/y+I2S3mwUq9t+EP
         HjvbQDHQVg9AU9Waos+hWcXUYyFWthjlFCcPyF8P+XZOYDaJMZ2WM1fjxN67zHY6sDHE
         I3vKogLzf2pxTerqExfL1o48dPdfxugY/LphHWYmzBD1VAe0waeuDuZKcVHPSN8MXgyf
         Ns8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dxe7pEHiiWXiBJZSIwOMrygbOqH/WOJMCAY2y1dqju4=;
        b=KUotU/drEHY/+hYE/FMIY8y5MKPYskIHuOLH8wIRhjaObI6dEB6CrImfLJgz9XD2xd
         2G6DDDrlmf97Sq3MY7fzBswOdYNLFNSGuZXv8FB7CunKzX39uEoA1W57pSXjAmBMRNUk
         a4VLFRGHdvRv/QzP7bs+qBInWWabn5f30L6ulndox9NcN8mxPdckRS1pcpZKY0Vv+0x5
         OwD7klMTYDyFadMC6umykjAE8vqMXtpxPQIEBomm7uAG000ByJr7d4z9JqD0J2dzSmJp
         yh7CYMCiYJZxJj/BiO0FJoBnuJXFhC20Gwh4xhdvsGx8pVRaL0nLRZ5y7E6YrcexchGI
         NTpQ==
X-Gm-Message-State: AOAM533m/hptQc2StyENrS9zybUrDd2XZDthtDtgwCau4rsgoUW4781U
        FwhdIGDn06JvQCOyj5ohNAo=
X-Google-Smtp-Source: ABdhPJwENLJX89fsjHpM6X4dwBQ384hf9gLzDPJNxS0+MuvoZoKkw53aFASVzGaPZkrblFcMr/3JKg==
X-Received: by 2002:a63:4a49:: with SMTP id j9mr885431pgl.234.1623197537234;
        Tue, 08 Jun 2021 17:12:17 -0700 (PDT)
Received: from sea3-br-agg-r2-ae105-0.amazon.com ([205.251.233.52])
        by smtp.googlemail.com with ESMTPSA id ge13sm3424124pjb.2.2021.06.08.17.12.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 Jun 2021 17:12:16 -0700 (PDT)
Message-ID: <1a6306bb029779e26d92ba3e2608e500ce47c6f7.camel@gmail.com>
Subject: Re: [RFC PATCH 1/1] arm64: implement live patching
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, catalin.marinas@arm.com,
        will@kernel.org, mark.rutland@arm.com,
        madvenka@linux.microsoft.com, duwe@lst.de, benh@kernel.crashing.org
Date:   Tue, 08 Jun 2021 17:12:15 -0700
In-Reply-To: <20210607170154.GC10625@sirena.org.uk>
References: <20210604235930.603-1-surajjs@amazon.com>
         <20210607170154.GC10625@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 2021-06-07 at 18:01 +0100, Mark Brown wrote:
> On Fri, Jun 04, 2021 at 04:59:30PM -0700, Suraj Jitindar Singh wrote:
> 
> > + * CONFIG_ARM64_BTI_KERNEL:
> > + *	- Inserts a hint #0x22 on function entry if the function is
> > called
> > + *	  indirectly (to satisfy BTI requirements), which is inserted
> > before
> > + *	  the two nops from above.
> 
> Please write out the symbolic name of the HINT (BTI C here) rather
> than
> the number, it helps with readability especially in a case like this
> where there are multiple relevant hints.

Thanks for taking a look, I will keep that in mind for when I resend.

