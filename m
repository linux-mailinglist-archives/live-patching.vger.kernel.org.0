Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 590E7DED5B
	for <lists+live-patching@lfdr.de>; Mon, 21 Oct 2019 15:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfJUNVA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Oct 2019 09:21:00 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28788 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728753AbfJUNU4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Oct 2019 09:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571664055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B4XWknMJuOuh6KIQuH7ppQMvEXTX2kO1s3vMco8Hg40=;
        b=XmVcOWgh9FUw9VSs335hS4IRfbXv5sFCP7+vv+4XwA6myZ+A5Ix+NgAk96EmSsjPWNOWr9
        iYas5cCR4Q71PZYZZzhNaETjwVnY+YUPADcK6UUtG4KhxfKl1E/fRDZI7NM2a/ITkwgkq/
        1CfM2Q4nvOGTCWIJjAhRL3ej2/ogr4s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-pDIa5xMtMX6HhtaRvjFBrQ-1; Mon, 21 Oct 2019 09:20:50 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F888800D41;
        Mon, 21 Oct 2019 13:20:48 +0000 (UTC)
Received: from treble (ovpn-123-96.rdu2.redhat.com [10.10.123.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 47C265B69A;
        Mon, 21 Oct 2019 13:20:46 +0000 (UTC)
Date:   Mon, 21 Oct 2019 08:20:44 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Torsten Duwe <duwe@lst.de>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Jiri Kosina <jikos@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Julien Thierry <julien.thierry@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        live-patching@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 0/5] arm64: ftrace with regs
Message-ID: <20191021132044.zkzclqtrexryyybl@treble>
References: <0f8d2e77-7e51-fba8-b179-102318d9ff84@arm.com>
 <20190311114945.GA5625@lst.de>
 <20190408153628.GL6139@lakrids.cambridge.arm.com>
 <20190409175238.GE9255@fuggles.cambridge.arm.com>
 <CAB=otbRXuDHSmh9NrGYoep=hxOKkXVsy6R84ACZ9xELwNr=4AA@mail.gmail.com>
 <20190724161500.GG2624@lakrids.cambridge.arm.com>
 <nycvar.YFH.7.76.1910161341520.13160@cbobk.fhfr.pm>
 <20191016175841.GF46264@lakrids.cambridge.arm.com>
 <20191018174100.GC18838@lakrids.cambridge.arm.com>
 <20191019130135.10de9324@blackhole.lan>
MIME-Version: 1.0
In-Reply-To: <20191019130135.10de9324@blackhole.lan>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: pDIa5xMtMX6HhtaRvjFBrQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat, Oct 19, 2019 at 01:01:35PM +0200, Torsten Duwe wrote:
> All calls going _out_ from the KLP module are newly generated, as part
> of the KLP module building process, and are thus aware of them being
> "extern" -- a PLT entry should be generated and accounted for in the
> KLP module.

Hm... for kpatch-build I assume we may need a GCC plugin to convert
local calls to global somehow?

--=20
Josh

