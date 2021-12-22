Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F08347D34A
	for <lists+live-patching@lfdr.de>; Wed, 22 Dec 2021 15:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbhLVOAs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Dec 2021 09:00:48 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:49608 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237349AbhLVOAs (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Dec 2021 09:00:48 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2178A212B7;
        Wed, 22 Dec 2021 14:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640181647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0utRSqmLOFDMTX1m4c/q1Eo/3WAVcqCk1NnGENJ0Dsg=;
        b=mJKlTWe2MOa4ObQhf1wxT2JppLXljYsNaqd5AEoJzBsLK5DAZo0V/lDIVhtxHdUX2mdU6I
        FCaC61JDBpjvUfbRPMgVa0fM3R6BhDgv7AXzssm03YPG8GRIsEpVm5dmDqm4BxTsoDHneH
        idq3SuNdKG3c2+R/dEvg33VOsvROeAw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640181647;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0utRSqmLOFDMTX1m4c/q1Eo/3WAVcqCk1NnGENJ0Dsg=;
        b=/CXr7qnTf483W1DHSVCZGHxApoDnDyO8hZhOwK7vrnOmADOpUTlBPsHmuwZXJD3qX4BlQj
        eMUS+aj3Hj8aBACg==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 02CD4A3B89;
        Wed, 22 Dec 2021 14:00:47 +0000 (UTC)
Date:   Wed, 22 Dec 2021 15:00:46 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Re: [PATCH v2 04/13] powerpc/ftrace: Add support for livepatch to
 PPC32
In-Reply-To: <63cb094125b6a6038c65eeac2abaabbabe63addd.1640017960.git.christophe.leroy@csgroup.eu>
Message-ID: <alpine.LSU.2.21.2112221459030.18494@pobox.suse.cz>
References: <cover.1640017960.git.christophe.leroy@csgroup.eu> <63cb094125b6a6038c65eeac2abaabbabe63addd.1640017960.git.christophe.leroy@csgroup.eu>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 20 Dec 2021, Christophe Leroy wrote:

> PPC64 needs some special logic to properly set up the TOC.
> See commit 85baa095497f ("powerpc/livepatch: Add live patching support
> on ppc64le") for details.
> 
> PPC32 doesn't have TOC so it doesn't need that logic, so adding
> LIVEPATCH support is straight forward.
> 
> Add CONFIG_LIVEPATCH_64 and move livepatch stack logic into that item.
> 
> Livepatch sample modules all work.

Great.
 
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>

FWIW the patch looks good to me.

Miroslav
