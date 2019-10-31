Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA9A1EB6A1
	for <lists+live-patching@lfdr.de>; Thu, 31 Oct 2019 19:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbfJaSHH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 31 Oct 2019 14:07:07 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54202 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726602AbfJaSHH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 31 Oct 2019 14:07:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572545226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NrlpMDqyr5ApHQr8gH6aDAnpSTedXQNFwuC3wOLm8ko=;
        b=EctAZ1qUzMtebvlaVfl5ZamQIvPo5R6UAUC8JTNL8d5J9ZRj0eIhEqrM82Bs+808UnruiB
        bh1INGRDvg01BR1hQBkFGhyZJklts20BfI2qQfLc27OwuY/VqSgSzEmAyGhiRVTBthTZGs
        kTKYrA8dDs6pwVJlVPGVwQ2X1m5HZ8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-xBD6-fgwN0qswE14Jqdc1A-1; Thu, 31 Oct 2019 14:07:00 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF3A5800EB6;
        Thu, 31 Oct 2019 18:06:59 +0000 (UTC)
Received: from treble (ovpn-124-23.rdu2.redhat.com [10.10.124.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 53EAA600CD;
        Thu, 31 Oct 2019 18:06:53 +0000 (UTC)
Date:   Thu, 31 Oct 2019 13:06:50 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] livepatch: new API to track system state changes
Message-ID: <20191031180650.g4tss4wfksg2bs6a@treble>
References: <20191030154313.13263-1-pmladek@suse.com>
MIME-Version: 1.0
In-Reply-To: <20191030154313.13263-1-pmladek@suse.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: xBD6-fgwN0qswE14Jqdc1A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 30, 2019 at 04:43:08PM +0100, Petr Mladek wrote:
> Hi,
>=20
> this is another piece in the puzzle that helps to maintain more
> livepatches.
>=20
> Especially pre/post (un)patch callbacks might change a system state.
> Any newly installed livepatch has to somehow deal with system state
> modifications done be already installed livepatches.
>=20
> This patchset provides a simple and generic API that
> helps to keep and pass information between the livepatches.
> It is also usable to prevent loading incompatible livepatches.
>=20
> Changes since v3:
>=20
>   + selftests compilation error [kbuild test robot]=09
>   + fix copyright in selftests [Joe]
>   + used macros for the module names in selftests [Joe]
>   + allow zero state version [Josh]
>   + slightly refactor the code for checking state version [Josh]
>   + fix few typos reported by checkpatch.pl [Petr]
>   + added Acks [Joe]

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

--=20
Josh

