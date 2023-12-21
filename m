Return-Path: <live-patching+bounces-101-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DA57181B947
	for <lists+live-patching@lfdr.de>; Thu, 21 Dec 2023 15:07:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 684C7B21161
	for <lists+live-patching@lfdr.de>; Thu, 21 Dec 2023 14:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D232953A04;
	Thu, 21 Dec 2023 14:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="ncGlqVgP"
X-Original-To: live-patching@vger.kernel.org
Received: from out203-205-221-231.mail.qq.com (out203-205-221-231.mail.qq.com [203.205.221.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E888539FF
	for <live-patching@vger.kernel.org>; Thu, 21 Dec 2023 14:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1703167568;
	bh=H0VD4ujMeAECYBqTt5DeFaQoK1Z2Jl2kmKmUmcSv2HY=;
	h=Subject:From:To:Date;
	b=ncGlqVgPEm7GX69AjpelcIcX/xos2wKokgFiJitjJ3F6LiwxCaREmTAJeyVAQUjZe
	 mRz1NF7nKyQk7LHht6dzsQcBOnDGzytjdySu6ugvRxFG5lPbea3sjVdIEdrsE4zmjA
	 /PRHSC1SLc62VXPrBU1OzMU+i4S178fNeWy+nJc4=
Received: from [192.168.216.104] ([60.17.2.135])
	by newxmesmtplogicsvrszc5-1.qq.com (NewEsmtp) with SMTP
	id 18711423; Thu, 21 Dec 2023 22:06:07 +0800
X-QQ-mid: xmsmtpt1703167567tbpvxk7bw
Message-ID: <tencent_8B36A9FCE07A8CA645DC6F3C3F039C52E407@qq.com>
X-QQ-XMAILINFO: NGsJ5Fy+2UsSMtYjBzOd8r1ulDvhdJ94FdJvaeRlK/2LgIWGmnUFqgv+BKMcn/
	 f01v31XS8q36xBxwuplhGtW6xNI7Vxi3EA/MvDwtHJztpc8eGeAEgTf7r1i2X3drQuXkMYKPGhAq
	 Y2P6xWFN/1zEKLGTqKFBzaCg0lKkNA2zbg4H+VUSMIE9AA6F3hbOITIhRGpJPe0rnlCgT6dRJ0XF
	 2WZn7sZSaIOTQh9K4ZC9Nf5hXX8lDfDketthKe2UTtAu8ymCM3adKjc4g3bQS9F7DrcPlmSUmYKZ
	 9AZe5EkIuM/XhR4Nc+1VE9bciM0pu/gRnZAV8PYZUCVjt9fp5DGuHWfBapqlK4VrQduJBKsfmsdE
	 x6Cu1BVTd3jBRn0wrI6C2er8a/GBwj87nDiQGEpb80e3sMZLoWkzd2Nfqs3PfhVpgEp6QSYmzakJ
	 zcbyDTPFu+efPS+KNQT1km0WV0uYaUR4MVV7euzOBwHTBjPMx5Yw+U+FpbAgQc44H7a7LJanXuSc
	 F5iBfltCSZiNcighNVc8IQLem1/TtQxQtHRZ7LHbEp/Q7Eu/XcpP8+OHtzF6xg3oJPsEyItcUtuX
	 vja//bqlz6AYBVfopB802NfqnXLd2fNf8XGmOmgSIQkPIuVYuYcZCi8uGkDPlq2fZ9Ydr7t3TObO
	 jKqqBNOibveKaoVxr//5gK614rDbrSu1idZF/c+CGZsvOgPB3tSEIK0AtqUsPzTGCjSdUMJQ+oeO
	 Kw/fwj020ijGA/83QjLyd4NQ2U4zxG15HDJ/BFIIbSEaTJkcX5UDLcU0cyq1Fm5BdnlYVLt4ZGq9
	 OIpFafCFzourDoRFfgWiFyAXoOZAuwktV7BR3exR7bnZPv2GH72e9CS3JAR0Ahv5rHs4WNg+BPId
	 ApoFztW1n7qfyLUJ/SCriwI0ZuKSjb+vbWaeuDgBX3huW3oNjEk1GxYBZ5x1G0JjD7OOYbVx2i/a
	 gDvVDumhEdp9JOp+zo2WSYpTeRRM0KVsa81kF9Gsc=
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
X-OQ-MSGID: <2c29eacc94fa584eeaa9b62fa25cbd6241d6ace2.camel@foxmail.com>
Subject: RFC: another way to make livepatch
From: laokz <laokz@foxmail.com>
To: live-patching@vger.kernel.org
Date: Thu, 21 Dec 2023 22:06:06 +0800
Autocrypt: addr=laokz@foxmail.com; prefer-encrypt=mutual;
 keydata=mQINBFzLu4QBEADMp82/D9QivTnSQpsbqOe7pXEIc5faAsUeCIKOuR8aHPFU0ddUrKbQuJ+63lwET+qrSFgdPUUR7QM7TEQWL9Jgiymxn9zhzjOc6MP6AJ58If2MsDQdn5PoDAZC12ERgr9ntsXi+MwaA0VFL6pvROOePyCKmhBLUjUnM3gOUsPauYp3c4oYhRfoJMadESZOeDKUYINZ8UVm+YtL/tJuwMy6QunGPzywe5wQ+Lhncstis55dpWaklkWG6X84MUNk3kSUp8vXgWEWfeRWuLlyd41sHhOFuwpBqZh2nRxskTJmivkEKxifxO+CDXhzFCW8pLb/FVShBmJ+Y/6RKzq4Afl4TxKIGTzXF5zjWr4LwZtLQ0MKHfEB+htfiUGo4TlKx/6Vo5Aqdls1pjv1wzUrbfuDpWu+wf8zyRMV5ku+KAikFlrjFbLi2IleyqGxBRA1LWUUBSnlXDDAjCZOeSFJmeB37hxlOgRl3tCRFvnk3Yu0inlIQHfX4V5YtHrHP9YoRJUfnpuG41uhSf9nJokhW3vnhbH2CmQZBNoWBqvH/E8gCdRBOj0nwA8BNFptSvInUZDlzkjSqbGeGo5fHiBSNS2lGG7uI2BezNFEELA4/F8g0JKvP12SvuBLbo2J7kwqj7wUm/2Ghk8WqWun86kyOzCQCtMaQPIBuun8/Nw32wK3BwARAQABtBlsYW9reiA8bGFva3pAZm94bWFpbC5jb20+iQJXBBMBCABBAhsDBQkFo5qABQsJCAcDBRUKCQgLBRYCAwEAAh4BAheAFiEEm5KEDfHGbzo225HGBu2+68u+gbIFAlzNCScCGQEACgkQBu2+68u+gbIPqxAArF+Q2N38Wn+GFivx7xfXNyK5hMYWkqnre9TAG/++q/0txtwqI7WKuJ6GAWFJSWXvAsvy5Gp4mGGoE6IWs55tTtIdfvfJBcJkRZTZJE7wR8FywoCb7D/LWDEip5XMZipF6
	ZZRlH1i87uQAZtW4Kq0EVmDOkGzCElzx34H83sk1FEjjAA20Q6KJSmad9xAytzCbZu1gJUQzKl9t9/zxgPWXeI+/6aFneN1Bv+Jde4kAgDviib68MUovQt5wSqZBwGE/5I3VdgQzPpC5bHWLj7/EycIHkK04C4ev1EAAk1mw94MsCIAcBnY7I7zTytNBbP15jS4RrgUCDbocS2o7H0WN/wz/EUBF4lKIlxcLGfwqSoGyzNNQ8rw6E7MkkTLJUZCavcYkDNr2ZAYW0EbBTsTBlh67ozExVQM1Dgo4N01RqFOe9uYCzCwpP1nlBzRa7mNb5O1F4L4hROs94f4hXje0cVd+W0PpNaR+iC05lvCVEyHV+dCWnK4cTLVWBuatJ1of6Oj0oF/s2boB35PFW4kD4/oFX7BUoA8U/Lf8NarOev3DIXkRNwOFL1lBClgMXFFoNFmj3xWrJaUAkil7FNEilZg/HVuTeaZNXZrGR9NWR6ZgDuyeS660XIEr3VqdTsplQF49nSUul64NNoRdgdXB2Or6SGq0egPx7FPthCXzi4=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2-1 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi,

Is it off-topic talking about livepatch making tool? I tried another way an=
d
want to get your expert opinion if there any fatal pitfall.

Thanks.

laokz


