Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3B32FF48A
	for <lists+live-patching@lfdr.de>; Thu, 21 Jan 2021 20:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbhAUTbr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jan 2021 14:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbhAUTFG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jan 2021 14:05:06 -0500
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A4FC061756
        for <live-patching@vger.kernel.org>; Thu, 21 Jan 2021 10:53:46 -0800 (PST)
Received: from lwn.net (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 91882615F;
        Thu, 21 Jan 2021 18:52:27 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 91882615F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1611255148; bh=TLHAsi6Ty8O0y2qbsmaLJjfL5054cf7/wZfX1o0btdA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HdMTC+/pzgwibyhHpFXEgZz4hQnlDgiLzf9Ir8UAu9s7MeI5KvP1UQIeF8rFflVGa
         9M++bSybS/4M0YWty863fPt/VmsUJxsK3x2URWh0RJh0B3snAmqy3MvdKyrPYuRpEg
         CTFRLehmTWSxPfhN7x3SGe0wCSAO5B2xxi20zocEjFIXF2vJWwFevX4R3dgn4Q1gwB
         evMHlfNrQmVbVAVLLxmEBy60zB2Ux53lh1gj94N8pYANebEk99GsHKbOTZt4sw2DTh
         rbQksh9CB1mEc7xiRnurSG0IYif2UReHx3SHfiRBzaXi43UeUTw2gB/IzukM9QoHbT
         vXJm+aqtme1hQ==
Date:   Thu, 21 Jan 2021 11:52:26 -0700
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-doc@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v6 0/2] Documentation: livepatch: Document reliable
 stacktrace and minor cleanup
Message-ID: <20210121115226.565790ef@lwn.net>
In-Reply-To: <20210120164714.16581-1-broonie@kernel.org>
References: <20210120164714.16581-1-broonie@kernel.org>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 20 Jan 2021 16:47:12 +0000
Mark Brown <broonie@kernel.org> wrote:

> This series adds a document, mainly written by Mark Rutland, which makes
> explicit the requirements for implementing reliable stacktrace in order
> to aid architectures adding this feature.  It also updates the other
> livepatching documents to use automatically generated tables of contents
> following review comments on Mark's document.

So...is this deemed ready and, if so, do you want it to go through the
docs tree or via some other path?

Thanks,

jon
